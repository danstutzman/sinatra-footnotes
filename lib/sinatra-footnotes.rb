require 'sinatra-footnotes/version'
require 'sinatra/base'

module Sinatra
  module Footnotes
    IGNORED_IVARS = %w[
      @default_layout
      @app
      @template_cache
      @env
      @request
      @response
      @params
    ]

    module Helpers
    end

    def self.registered(app)
      app.helpers Footnotes::Helpers

      app.after do
        ivars = instance_variables - IGNORED_IVARS.map { |ivar| ivar.intern }
        list_items = ivars.map { |ivar| "<li>#{ivar}</li>\n" }
        response.body +=
          ["<hr>\nInstance vars\n<ul>\n#{list_items.join}</ul>\n"]
      end
    end
  end

  register Footnotes
end
