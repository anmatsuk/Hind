#!/usr/bin/ruby

require "oauth2"
require "json"
require 'timeout'


begin
	  file = File.read('secret.json')
	  data_hash = JSON.parse(file)
	  retries ||= 0
	  if (retries == 4)
		  return (1)
	  end
	  if (retries != 0)
		sleep(5)
		print "api dead , trying again ... (#{retries})\n"
	  end
	    retries += 1
	    client = OAuth2::Client.new(data_hash['UID'], data_hash['SECRET'], site: "https://api.intra.42.fr")
	    token = client.client_credentials.get_token
	    raise "the roof"
rescue 
	  retry if token == nil
end


RequestedUser = {}
begin
	File.open(ARGV[0], "r") do |f|
	f.each_line do |line|
		RequestedUser[line.chomp] = "isn't online!"
		end
	end
rescue Errno::ENOENT, TypeError
		puts "No file :'("
			exit -1
end
begin
	RequestedUser.keys.each do |key|
		print key
		user = token.get("/v2/users?filter[login]=#{key}").parsed;
		print ":  "
		if (user == [])
			print "user not created ..."
		else
			host = token.get("/v2/users/#{key}/locations?active==true").parsed
			if (host[0]['end_at'] == nil)
				print host[0]['host']
			else
				print "user not active"
			end
		end
		print "\n";
	end	
end
