#!env ruby
#coding: utf-8

load "transmission.rb"
load "config.rb"


tc = Transmission.new(@url)
tc.all.each_slice(5) do |ids|

data = tc.get(ids)
    data["arguments"]["torrents"].each do |t|
        if t["error"] != 0
            puts "Error in torrent #{t["name"]}: #{t["errorString"]}"
            if t["errorString"].match(/Unregistered.torrent/)
                puts "    Deleting unregistered #{t["name"]} #{t["id"]}"
                tc.delete(t["id"], @remove_files)
                next
            end
        end
    end

end