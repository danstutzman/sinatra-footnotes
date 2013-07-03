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
      def html_for_instance_variables
        ivars = instance_variables - IGNORED_IVARS.map { |ivar| ivar.intern }

        htmls = []
        htmls.push "<hr>"
        htmls.push "Instance vars"
        htmls.push "<table>"
        htmls.push "<tr><th>Name</th><th>Value</th></tr>"
        ivars.each do |ivar|
          htmls.push "<tr>"
          htmls.push "<td>#{ivar}</td>"
          htmls.push "<td>#{instance_variable_get(ivar).inspect}</td>"
          htmls.push "</tr>"
        end
        htmls.push "</table>"

        htmls.join("\n")
      end

      def html_for_params
        htmls = []
        htmls.push "<hr>"
        htmls.push "Params:"
        htmls.push "<table>"
        htmls.push "<tr><th>Name</th><th>Value</th></tr>"
        params.each do |name, value|
          htmls.push "<tr>"
          htmls.push "<td>#{name.intern.inspect}</td>"
          htmls.push "<td>#{value.inspect}</td>"
          htmls.push "</tr>"
        end
        htmls.push "</table>"

        htmls.join("\n")
      end
    end

    def self.registered(app)
      app.helpers Footnotes::Helpers

      app.after do
        response.body.push html_for_instance_variables
        response.body.push html_for_params
      end
    end
  end

  register Footnotes
end
