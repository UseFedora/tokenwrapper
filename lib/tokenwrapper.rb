require './tokenwrapper/version'
require 'net/http'
require 'uri'
require 'json'
require 'date'

module Tokenwrapper
  def Tokenwrapper.getToken	
    uri = URI.parse("http://todoable.teachable.tech/api/authenticate")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth("pnk8000@rit.edu", "todoable")
    request.content_type = "application/json"
    request["Accept"] = "application/json"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
	if response.code.eql?("200")
      t = Token.new(response)
	end
	t
  end
  
  class Token
    def initialize(apiResponse)
      tempHash = JSON.parse(apiResponse.body)
	  @tcode = tempHash["token"]
	  @texpiration = DateTime.parse(tempHash["expires_at"])
	end
	def getCode
	  @tcode
	end
	def getExpireTime
	  @texpiration
	end
  end
end
