#
# purge_cloudflare.rb: purge caches on Cloudflare by diary updates
#
# Copyright (C) 2020, TADA Tadashi <t@tdtds.jp>
# SPDX-License-Identifier: GPL-2.0-or-later
#

# curl -sX POST "https://api.cloudflare.com/client/v4/zones/#{CLOUDFLARE_ZONE_ID}/purge_cache" \
#     -H "Authorization: Bearer #{CLOUDFLARE_API_TOKEN}" \
#     -H "Content-Type:application/json" \
#     --data '{"files":["https://tdiary.org/"]}'
# => {
#      "result": {"id": "ac2fe5d7b76bfe5748237ca105e6445e"},
#      "success": true,
#      "errors": [],
#      "messages": []
#    }
require 'net/http'
require 'json'

def cloudflare_purge_cache(pages = nil)
	token = ENV['CLOUDFLARE_API_TOKEN']
	zone = ENV['CLOUDFLARE_ZONE_ID']

	uri = URI("https://api.cloudflare.com/client/v4/zones/#{zone}/purge_cache")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true

	headers = {
		"Content-Type" => "application/json",
		"Authorization" => "Bearer #{token}"
	}
	params = {"purge_everything" => true}
	if pages
		params = {
			"files" => pages.append('', 'index.rdf').map{|u|"https://tdiary.org/#{u}"}
		}
	end
	res = http.post(uri.path, params.to_json, headers)
	puts "purge cache result: #{res.code} #{res.body}"
	return res.code
end

add_purge_cache_proc do |pages|
	cloudflare_purge_cache(pages)
end
