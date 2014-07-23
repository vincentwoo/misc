require 'json'
require 'rest-client'

URL = 'https://api.spoonrocket.com/userapi/menu?zone_id=2'

while true
  data = JSON.parse RestClient.get URL
  menu = data['menu']
  if menu.any? { |m| !m['sold_out_temporarily'] }
    `say "spoonrocket go go go"`
  end
  sleep 5
end
