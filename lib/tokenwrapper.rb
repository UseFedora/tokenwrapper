require './tokenwrapper/version'
require 'net/http'
require 'uri'
require 'json'
require 'date'

module Tokenwrapper
  def Tokenwrapper.getToken
	t = Token.getInstance
  end
  class Token
    $instance = nil
	def initialize  	 
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
      tempHash = JSON.parse(response.body)
	  @tcode = tempHash["token"]
	  @texpiration = DateTime.parse(tempHash["expires_at"]).to_time.utc
	end
	
	def self.getInstance
	  if $instance == nil
		$instance = Token.new
	  elsif $instance.expiresSoon
		$instance = Token.new
	  end 
		$instance
	end

	def getCode
	  @tcode
	end

	def getExpireTime
	  @texpiration
	end
    
	def expiresSoon
	  (getExpireTime - Time.now.utc) < 60
	end
  end
end
puts Tokenwrapper.getToken.getCode
puts Tokenwrapper.getToken.getCode
