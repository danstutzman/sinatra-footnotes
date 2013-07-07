require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class SinatraRoutesNote < AbstractNote
      def initialize(controller)
        @controller = controller
        @parsed_routes = parse_routes(controller)
      end

      def title
        "Routes (#{@parsed_routes.size})" # don't show 'SinatraRoutes'
      end

      def legend
        'Routes'
      end

      def content
        #mount_table(@parsed_routes.unshift([:path, :name, :options, :requirements]), :summary => "Debug information for #{title}")
        mount_table(@parsed_routes.unshift([:method, :path]), :summary => "Debug information for #{title}")
      end

      protected
      def parse_routes(controller)
        # thanks to cldwalker's tux gem for this code to interpret Sinatra routes
        routes = controller.routes.inject([]) {|arr, (k,v)|
          arr += v.map {|regex,params,*|
            path = params.empty? ? regex.inspect :
              params.inject(regex.inspect) {|s,e| s.sub(/\([^()]+\)/, ":#{e}") }
            [k, (str = path[%r{/\^(.*)\$/}, 1]) ? str.tr('\\', '') : path]
          }
        }
        
        # still need to pull the regex syntax out
        routes = routes.map do |method_and_path|
          method, path = method_and_path
          path =
            path.to_s.gsub("\\/", "/").gsub(%r[^/\\A], "").gsub(%r[\\z/$], "")
          [method, path]
        end
        
        # don't show HEAD requests
        routes = routes.reject! do |method_and_path|
          method_and_path[0] == 'HEAD'
        end
        
        routes
      end
    end
  end
end
