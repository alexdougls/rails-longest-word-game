require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alpha_array = ('A'..'Z').to_a * 10
    @grid = alpha_array.sample(10)
  end

  def score
    @word = params[:word]
    @grid = params[:grid].gsub(/\s+/, '').chars

    if api_attempt?(@word) && grid_attempt?(@word, @grid)
      @results = "Congratulations, #{@word} is a valid english word"
    elsif grid_attempt?(@word, @grid) && !api_attempt?(@word)
      @results = "Sorry but #{@word} is not a valid english word"
    elsif api_attempt?(@word) && !grid_attempt?(@word, @grid)
      @results = "Sorry but #{@word} is not part of #{params[:grid]}"
    else
      @results = "Sorry but no one knows what you're talking about.."
    end
  end

  def grid_attempt?(word, grid)
    word_chared = word.upcase.strip.chars
    word_chared.all? do |letter|
      word_chared.count(letter) <= grid.count(letter)
    end
  end

  def api_attempt?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = open(url).read
    attempt_parsed = JSON.parse(attempt_serialized)
    attempt_parsed['found']
  end
end
