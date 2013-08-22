require 'sinatra'

# use Rack::Session::Cookie, secret: SecureRandom.hex
# require 'rack-flash'
# use Rack::Flash, sweep: true

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib")
require 'sinatra-footnotes'

get "/" do
  @a = 1
end
