require 'sinatra-footnotes/version'
require 'sinatra/base'

dir = File.dirname(__FILE__)
%w[session cookies params sinatra_routes env assigns].each do |prefix|
  require File.join(dir, 'sinatra-footnotes', 'notes', "#{prefix}_note.rb")
end

module Sinatra
  module Footnotes
    module Helpers
      # Process notes to get javascript code to close them.
      #
      def close_helper(note)
        "Footnotes.hide(document.getElementById('#{note.to_sym}_debug_info'));\n"
      end

      # Helper that creates the link and javascript code when note is clicked
      #
      def link_helper(note)
        onclick = note.onclick
        unless href = note.link
          href = '#'
          onclick ||= "Footnotes.hideAllAndToggle('#{note.to_sym}_debug_info');return false;" if note.has_fieldset?
        end

        "<a href=\"#{href}\" onclick=\"#{onclick}\">#{note.title}</a>"
      end

      def each_with_rescue(notes)
        notes.each do |note|
          begin
            yield note
          rescue Exception => e
            STDERR.puts "FootNotes #{note.to_s.camelize}NoteException"
            STDERR.puts e
          end
        end
      end

      def fieldsets(notes)
        content = ''
        each_with_rescue(notes) do |note|
          next unless note.has_fieldset?
          content << <<-HTML
            <fieldset id="#{note.to_sym}_debug_info" style="display: none">
              <legend>#{note.legend}</legend>
              <div>#{note.content}</div>
            </fieldset>
          HTML
        end
        content
      end
    end

    def self.registered(app)
      app.helpers Footnotes::Helpers

      app.after do
        style_path = File.join(
          File.dirname(__FILE__), 'sinatra-footnotes', 'style.html')
        response.body.push File.read(style_path)

        response.body.push '<!-- Footnotes -->'
        response.body.push '<div style="clear:both"></div>'
        response.body.push '<div id="footnotes_debug">'
        response.body.push 'Show:'

        notes = []
        notes.push ::Footnotes::Notes::SessionNote.new(self)
        notes.push ::Footnotes::Notes::CookiesNote.new(self.request)
        notes.push ::Footnotes::Notes::ParamsNote.new(self)
        notes.push ::Footnotes::Notes::SinatraRoutesNote.new(app)
        notes.push ::Footnotes::Notes::EnvNote.new(self)
        notes.push(::Footnotes::Notes::AssignsNote.new(self).tap do |note|
          note.ignored_assigns = [:@default_layout, :@app, :@template_cache,
                                  :@env, :@request, :@response, :@params,
                                  :@preferred_extension, :@_out_buf]
        end)

        response.body.push notes.map { |note| link_helper(note) }.join(' | ')
        response.body.push '<br />'

        response.body.push fieldsets(notes)

        script_path = File.join(
          File.dirname(__FILE__), 'sinatra-footnotes', 'script.html')
        response.body.push(File.read(script_path))

        response.body.push '</div>'
        response.body.push '<!-- End Footnotes -->'
      end
    end
  end

  register Footnotes
end
