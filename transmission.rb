#!env ruby
#coding: utf-8
require "json"
require "httparty"

class Transmission
	attr_reader :url, :session_id
	def initialize(url = "http://localhost:9091/transmission/web/")
		@url = url
		@session_id = "NOT-INITIALIZED"
	end

	def request(method, args)
		req = {
			:body => {
				"method" => method,
				"arguments" => args
			}.to_json,
			:headers => { "x-transmission-session-id" => @session_id }
		}
		res = HTTParty.post(@url, req)
		if( res.code == 409 and @session_id == "NOT-INITIALIZED")
			@session_id = res.headers["x-transmission-session-id"].strip
			return request(method, args)
		else
			return res
		end

	end
	
	def all()
		args = {"fields" => ["id"]}
		r = request("torrent-get", args)
		return JSON.parse(r.body)["arguments"]["torrents"].map{|i| i["id"]}.uniq
	end
	def move(ids, dst)
		args = {"ids" => ids, "move" => true, "location" => dst}
		r = request("torrent-set-location", args)
		return JSON.parse(r.body)
	end	

	def get(ids)
		args = {"fields" => ["downloadDir", "trackers", "status", "error", "errorString", "name", "id"], "ids" => ids}
		r = request("torrent-get", args)
		return JSON.parse(r.body)
	end

	def delete(id, delete_data)
		args = {"ids" => [id], "delete-local-data" => delete_data}
		r = request("torrent-remove", args)
		return JSON.parse(r.body)
	end

	def get_tracker_path(t)
		if t["trackers"].count != 1
			return "_public_torrent"
		end
		return URI.parse(t["trackers"].first["announce"]).host
	end
	
	
end

