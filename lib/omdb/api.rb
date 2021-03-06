require 'omdb/network'
require 'omdb/movie'
module Omdb
  class Api
    def search(search_term)
      res = network.call({s: search_term})
      if res[:data]["Response"] == "False"
        response = {
          movies: {},
          status: 404
        }
      else
        response = {
          movies: parse_movies(res[:data]),
          status: res[:code]
        }
      end
    end

    def fetch(title, year = nil)
      res = network.call({t: title, year: nil})
      if res[:data]["Response"] == "False"
        response = {:status => 404}
      else
        response = {
          status: res[:code],
          movie: parse_movie(res[:data])
        }
      end
    end

    private
    def parse_movies(json_string)
      data = json_string["Search"]
      movies = Array.new
      data.each do |movie|
        movies.push(parse_movie(movie))
      end
      return movies
    end

    def parse_movie(data)
      Movie.new(data)
    end

    def network
      @network ||= Omdb::Network.new
    end
  end
end
