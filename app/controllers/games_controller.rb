require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
  end

  def score
    @letters = params[:letters].scan(/\w/)
    if word_english?(params[:word]) == false
      @result = "Sorry but #{params[:word]} is not a valid English word"
    elsif letter_given?(params[:word], @letters) == false
      @result = "Sorry but #{params[:word]} cannot be build from #{@letters.join}"
    else
      @result = "Congratulations! #{params[:word]} is a valid english word "
    end
  end

  def word_english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    entry = open(url).read
    dictionary_entry = JSON.parse(entry)
    dictionary_entry['found']
  end

  def letter_given?(attempt, grid)
    # TODO: return false if the chosen word includes letters not from the grid or to many letters from the grid

    # Transform grid letters to downcase
    grid_downcase = []
    grid.each do |letter|
      grid_downcase << letter.downcase
    end

    # Transform attempt into an array of characters
    word_letters = attempt.scan(/\w/)

    result = true
    word_letters.each do |letter|
      result = false if !grid_downcase.include?(letter) || word_letters.count(letter) > grid_downcase.count(letter)
    end
    return result
  end
end
