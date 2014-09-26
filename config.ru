require 'rack'
require 'json'
require 'net/http'
require 'ruby_cop'

app = proc do |env|
  req = Rack::Request.new(env)
  path = req.path
  gist = Net::HTTP.get(URI("https://gist.githubusercontent.com#{path}/raw"))
  response = {}
  policy = RubyCop::Policy.new
  begin
    ast = RubyCop::NodeBuilder.build(gist)
    if ast.accept(policy)
      response[:result] = eval(gist)
      response[:error] = false
    else
      response[:result] = 'INVALID METHOD FOUND'
      response[:error] = true
    end

  rescue SyntaxError => se
    response[:result] = se.to_s
    response[:error] = true
  end
  [
    200,          # Status code
    {             # Response headers
      'Content-Type' => 'text/json',
    },
    [response.to_json]   # Response body
  ]
end

use Rack::CommonLogger
run app
