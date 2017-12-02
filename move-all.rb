#!env ruby
#coding: utf-8

load "transmission.rb"
load "config.rb"

tc = Transmission.new(@url)
tc.all.each_slice(5) do |ids|

    data = tc.get(ids)
    data["arguments"]["torrents"].each do |t|
        if t["downloadDir"].match(Regexp.new(@destination)) 
            #it is already in proper directory.
            next
        end

        if t["status"] == 4 || t["status"] == 2
            puts "Will not modify unfinished torrents: #{t["name"]} #{t["status"]}" 
            next
        end

        if t["error"] != 0
            puts "Skipping #{t["name"]} due to error #{t["error"]}: #{t["errorString"]}"
            next
        end
        path = tc.get_tracker_path(t)
        puts "Moving #{t["name"]} from #{t["downloadDir"]} to #{@destination}/#{path}/"
        
        tc.move(t["id"], "#{@destination}/#{path}/")
    end

end
