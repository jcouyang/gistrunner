# encoding: utf-8
require 'rack'
require 'timeout'
require 'rack/contrib'
require 'json'
require 'open-uri'
require_relative 'lib/ruby_cop'
require 'pry'
use Rack::JSONP
use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => :any
  end
end

require 'newrelic_rpm'

app = proc do |env|
  req = Rack::Request.new(env)
  path = req.path
  begin
    response = {}
    gist = open("https://gist.githubusercontent.com#{path}/raw").read.force_encoding(::Encoding::UTF_8)
    policy = RubyCop::Policy.new
    response[:error] = false
    ast = RubyCop::NodeBuilder.build(gist)
    params = req.params
    if ast.accept(policy)
      status = Timeout::timeout(15) {
        response[:result] = eval(gist)
      }
    else
      response[:result] = 'UNSAFE CODE!!'
      response[:error] = true
    end
  rescue ScriptError => se
    response[:result] = se.to_s
    response[:error] = true
  rescue StandardError => e
    response[:result] = e.to_s
    response[:error] = true
  end
  [
    200,          # Status code
    {             # Response headers
      'Content-Type' => 'application/json',
    },
    [response.to_json]   # Response body
  ]
end

use Rack::CommonLogger
run app
