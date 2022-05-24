require 'rest-client'
require 'json'

module DataFetcher

  class CARestAPIQuery

    def initialize(no_of_bits=2048, start_date_time)
      @url = "http://localhost:3002/certificate?no_of_bits=#{no_of_bits}&start_date_time=#{start_date_time}"
      @headers = {}
    end

    def get_data
      JSON.parse(query.body)
    end

    private

    def query
      RestClient.get(@url, @headers)
    end

  end

end
