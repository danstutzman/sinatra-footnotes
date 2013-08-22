require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class FlashNote < AbstractNote
      def initialize(controller)
        @flash = {}
        if controller.respond_to? :flash
          controller.flash.keys.each do |key|
            @flash[key] = controller.flash[key]
          end
        end
      end

      def title
        "Flash (#{@flash.length})"
      end

      def content
        mount_table_for_hash(@flash, :summary => "Debug information for #{title}")
      end
    end
  end
end
