require 'sinatra'
require 'sinatra_more/markup_plugin'
require 'json'
require 'rack-flash'

use Rack::Session::Cookie, secret: SecureRandom.hex
use Rack::Flash, sweep: true

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib")
require 'sinatra-footnotes'

get "/" do
  @a = 1
end
