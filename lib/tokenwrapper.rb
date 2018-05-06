require './tokenwrapper/version'
require 'net/http'
require 'uri'
require 'json'

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
	response
  end
getToken
end
