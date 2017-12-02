#!env ruby
#coding: utf-8

load "transmission.rb"
load "config.rb"

id = ENV["TR_TORRENT_ID"].to_i
if id.nil? || id == 0
    puts "This script should be called by transmission"
    exit
end

def find_label(path)
    @labels.each_key do |label|
        if @labels[label].map{ |i| ! path.match(i).nil?}.any?
            return label
        end
    end
    return nil
end


tc = Transmission.new(@url)
data = tc.get([id])
data["arguments"]["torrents"].each do |t|
    if t["downloadDir"].match(Regexp.new(@destination)) 
        #it is already in proper directory.
        #next
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

    puts find_label(path)
end
