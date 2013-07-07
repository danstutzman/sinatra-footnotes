require 'sinatra'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/lib")
require 'sinatra-footnotes'

get "/" do
  @a = 1
end
