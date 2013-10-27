require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class ParamsNote < AbstractNote
      def initialize(controller)
        @params = make_keys_strings(controller.params)
      end

      def title
        "Params (#{@params.length})"
      end

      def content
        mount_table_for_hash(@params, :summary => "Debug information for #{title}")
      end

      private
      def make_keys_strings(hash)
        hash.inject({}) do |output, key_value|
          key, value = key_value
          output.update({ key.to_s => value })
        end
      end
    end
  end
end
