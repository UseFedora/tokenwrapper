require './tokenwrapper/version'
require 'net/http'
require 'uri'
require 'json'
require 'date'

module Tokenwrapper
  def Tokenwrapper.getToken
	t = Token.getInstance
  end
  
  def Tokenwrapper.getAllLists
    t = Tokenwrapper.getToken
	
	uri = URI.parse("http://todoable.teachable.tech/api/lists")
	request = Net::HTTP::Get.new(uri)
	request.content_type = "application/json"
	request["Authorization"] = "Token token=\"%s\"" % t.getCode
	request["Accept"] = "application/json"

	req_options = {
	  use_ssl: uri.scheme == "https",
	}

	response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	  http.request(request)
	end
	tempHash = JSON.parse(response.body)
	tempHash["lists"]
	puts response.body
  end

  def Tokenwrapper.postList(listName)
    t = Tokenwrapper.getToken
	uri = URI.parse("http://todoable.teachable.tech/api/lists")
	request = Net::HTTP::Post.new(uri)
	request.content_type = "application/json"
	request["Authorization"] = "Token token=\"%s\"" % t.getCode
	request["Accept"] = "application/json"
	request.body = "list {
						   name: %s
						 }
					}" %listName
	
	req_options = {
	  use_ssl: uri.scheme == "https",
	}

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	  http.request(request)
	end
    response.code == "201"
  end

  def getList(id)
    
    t = Tokenwrapper.getToken
	
	uri = URI.parse("http://todoable.teachable.tech/api/lists/%d" %id)
	request = Net::HTTP::Get.new(uri)
	request.content_type = "application/json"
	request["Authorization"] = "Token token=\"%s\"" % t.getCode
	request["Accept"] = "application/json"

	req_options = {
	  use_ssl: uri.scheme == "https",
	}

	response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
	  http.request(request)
	end
	tempHash = JSON.parse(response.body)
	tempHash["lists"]
	puts response.body
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
	  elsif $instance.expiresSoon?
		$instance = Token.new
	  end 
		$instance
	end

	def getCode
	  refreshIfExpiresSoon
	  @tcode
	end

	def getExpireTime
	  @texpiration
	end
    
	def expiresSoon?
	  (getExpireTime - Time.now.utc) < 60
	end

	def refreshIfExpiresSoon
      if expiresSoon?
		getInstance
	  end
	end
  end
end
