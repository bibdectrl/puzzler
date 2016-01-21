module Puzzle

  def self.make_dict words, max_length
    word_file = File.new(words, "r")
    dict = Hash.new
    (1..max_length).to_a.each do |num|
      dict[num] = []
    end
    word_file.each do |line|
      word = line.chomp
      if word.length <= max_length and word.length > 0
        word_length = word.length - word.count("-")
        dict[word_length].push word
      end
    end
    return dict
  end
  
  WORD_DICT = make_dict("wordlist.txt", 50)

  class Puzzler
    attr_accessor :matches
    def initialize target
      regex = make_regex target
      target_length = target.length - target.count("-")
      @matches = get_matches WORD_DICT[target_length], regex
    end
    
    def get_matches(words, regex)
      puts regex
      matches = []
      words.each do |word| 
        if regex.match word then matches.push word end
      end
      matches
    end
    
    def make_regex string
      Regexp.new(string.downcase.split("").map {|x| if x.match /[a-z]|-/ then x else '.' end}.join)
    end    
  end
  
end


require 'sinatra'
require 'json'

get '/' do

  erb :index

end

get '/results/?:word?' do
  word = params[:word]
  @puzzler = Puzzle::Puzzler.new word
end

require 'json'

get '/api/results/?:word?' do
  word = params[:word]
  results = Puzzle::Puzzler.new word
  content_type :json
  { "results" => results.matches }.to_json                                                                                                                                                          
end



