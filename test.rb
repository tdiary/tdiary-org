# curl -sX POST "https://api.cloudflare.com/client/v4/zones/#{CLOUDFLARE_ZONE_ID}/purge_cache" \                           [purge_cache]
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

ZONE = "ac2fe5d7b76bfe5748237ca105e6445e"
TOKEN = "W3ilwbQM9iPxu7QLpEBj6bEivTe5k5LIWekLa1Fj"

uri = URI("https://api.cloudflare.com/client/v4/zones/#{ZONE}/purge_cache")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
params = {"files" => ["https://tdiary.org/"]}
headers = {
	"Content-Type" => "application/json",
	"Authorization" => "Bearer #{TOKEN}"
}
res = http.post(uri.path, params.to_json, headers)

p res.code
p res.body
