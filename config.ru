require 'rack'
require 'json'

app = proc do |env|
  $SAFE=2

  response = []
  response << 'a'
  response <<   eval("a = 123")
  [
    200,          # Status code
    {             # Response headers
      'Content-Type' => 'text/json',
    },
    response   # Response body
  ]
end

use Rack::CommonLogger
run app
