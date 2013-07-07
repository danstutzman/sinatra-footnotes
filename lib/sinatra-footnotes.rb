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
response.body.push(%[
        <!-- Footnotes Style -->
        <style type="text/css">
          #footnotes_debug {font-size: 11px; font-weight: normal; margin: 2em 0 1em 0; text-align: center; color: #444; line-height: 16px;}
          #footnotes_debug th, #footnotes_debug td {color: #444; line-height: 18px;}
          #footnotes_debug a {color: #9b1b1b; font-weight: inherit; text-decoration: none; line-height: 18px;}
          #footnotes_debug table {text-align: center;}
          #footnotes_debug table td {padding: 0 5px;}
          #footnotes_debug tbody {text-align: left;}
          #footnotes_debug .name_values td {vertical-align: top;}
          #footnotes_debug legend {background-color: #fff;}
          #footnotes_debug fieldset {text-align: left; border: 1px dashed #aaa; padding: 0.5em 1em 1em 1em; margin: 1em 2em; color: #444; background-color: #FFF;}
          /* Aditional Stylesheets */
          
        </style>
        <!-- End Footnotes Style -->

])
response.body.push('<!-- Footnotes -->')
response.body.push(%Q!
        <div style="clear:both"></div>
        <div id="footnotes_debug">
Show: <a href="#" onclick="Footnotes.hideAllAndToggle('session_debug_info');return false;">Session (2)</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('cookies_debug_info');return false;">Cookies (0)</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('params_debug_info');return false;">Params (2)</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('filters_debug_info');return false;">Filters</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('routes_debug_info');return false;">Routes</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('env_debug_info');return false;">Env</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('queries_debug_info');return false;">        <span style="background-color:#ffffff">Queries (3)</span>
        <span style="background-color:#ff0000">DB (156.815ms)</span>
</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('log_debug_info');return false;">Log (0)</a> | 
<a href="#" onclick="Footnotes.hideAllAndToggle('general_debug_info');return false;">General Debug</a><br />
            <fieldset id="session_debug_info" style="display: none">
              <legend>Session</legend>
              <div>          <table class="name_value" summary="Debug information for Session (2)" >
            <thead><tr><th>Name</th><th>Value</th></tr></thead>
            <tbody><tr><td>:session_id</td><td>"d1cc25db5c1c9c26bee44fc26bf0db33"</td></tr><tr><td>:_csrf_token</td><td>"sY7knthPDfnRYw0Njbr42fyOxUnqF2vbCxL1av4VCxE="</td></tr></tbody>
          </table>
</div>
            </fieldset>
            <fieldset id="cookies_debug_info" style="display: none">
              <legend>Cookies</legend>
              <div></div>
            </fieldset>
            <fieldset id="params_debug_info" style="display: none">
              <legend>Params</legend>
              <div>          <table class="name_value" summary="Debug information for Params (2)" >
            <thead><tr><th>Name</th><th>Value</th></tr></thead>
            <tbody><tr><td>:controller</td><td>"main"</td></tr><tr><td>:action</td><td>"form"</td></tr></tbody>
          </table>
</div>
            </fieldset>
            <fieldset id="filters_debug_info" style="display: none">
              <legend>Filter chain for MainController</legend>
              <div></div>
            </fieldset>
            <fieldset id="routes_debug_info" style="display: none">
              <legend>Routes for MainController</legend>
              <div>          <table summary="Debug information for Routes" >
            <thead><tr><th>Path</th><th>Name</th><th>Options</th><th>Requirements</th></tr></thead>
            <tbody><tr><td>form</td><td>request_method</td><td>{:action=>"form"}</td><td>{:request_method=>/^GET$/}</td></tr><tr><td>upload</td><td>request_method</td><td>{:action=>"upload"}</td><td>{:request_method=>/^POST$/}</td></tr><tr><td>image_data</td><td>request_method</td><td>{:action=>"image_data"}</td><td>{:request_method=>/^GET$/}</td></tr></tbody>
          </table>
</div>
            </fieldset>
            <fieldset id="env_debug_info" style="display: none">
              <legend>Env</legend>
              <div>          <table >
            <thead><tr><th>Key</th><th>Value</th></tr></thead>
            <tbody><tr><td>GATEWAY_INTERFACE</td><td>CGI/1.1</td></tr><tr><td>HTTP_ACCEPT</td><td>text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8</td></tr><tr><td>HTTP_ACCEPT_ENCODING</td><td>gzip,deflate,sdch</td></tr><tr><td>HTTP_ACCEPT_LANGUAGE</td><td>en-US,en;q=0.8</td></tr><tr><td>HTTP_CONNECTION</td><td>keep-alive</td></tr><tr><td>HTTP_HOST</td><td>localhost:3000</td></tr><tr><td>HTTP_USER_AGENT</td><td>Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36</td></tr><tr><td>HTTP_VERSION</td><td>HTTP/1.1</td></tr><tr><td>ORIGINAL_FULLPATH</td><td>/</td></tr><tr><td>PATH_INFO</td><td>/</td></tr><tr><td>QUERY_STRING</td><td></td></tr><tr><td>REMOTE_ADDR</td><td>127.0.0.1</td></tr><tr><td>REMOTE_HOST</td><td>localhost</td></tr><tr><td>REQUEST_METHOD</td><td>GET</td></tr><tr><td>REQUEST_PATH</td><td>/</td></tr><tr><td>REQUEST_URI</td><td>http://localhost:3000/</td></tr><tr><td>SCRIPT_NAME</td><td></td></tr><tr><td>SERVER_NAME</td><td>localhost</td></tr><tr><td>SERVER_PORT</td><td>3000</td></tr><tr><td>SERVER_PROTOCOL</td><td>HTTP/1.1</td></tr><tr><td>SERVER_SOFTWARE</td><td>WEBrick/1.3.1 (Ruby/2.0.0/2013-06-27)</td></tr><tr><td>action_controller.instance</td><td>#&lt;MainController:0x00000101535690&gt;</td></tr><tr><td>action_dispatch.backtrace_cleaner</td><td>#&lt;Rails::BacktraceCleaner:0x00000100d34888&gt;</td></tr><tr><td>action_dispatch.cookies</td><td>#&lt;ActionDispatch::Cookies::CookieJar:0x000001014443a8&gt;</td></tr><tr><td>action_dispatch.logger</td><td>#&lt;ActiveSupport::TaggedLogging:0x00000100d1fbe0&gt;</td></tr><tr><td>action_dispatch.parameter_filter</td><td>[:password]</td></tr><tr><td>action_dispatch.remote_ip</td><td>127.0.0.1</td></tr><tr><td>action_dispatch.request.content_type</td><td></td></tr><tr><td>action_dispatch.request.formats</td><td>[#&lt;Mime::Type:0x00000100c1d148 @synonyms=["application/xhtml+xml"], @symbol=:html, @string="text/html"&gt;]</td></tr><tr><td>action_dispatch.request.parameters</td><td>{"controller"=&gt;"main", "action"=&gt;"form"}</td></tr><tr><td>action_dispatch.request.path_parameters</td><td>{:controller=&gt;"main", :action=&gt;"form"}</td></tr><tr><td>action_dispatch.request.query_parameters</td><td>{}</td></tr><tr><td>action_dispatch.request.request_parameters</td><td>{}</td></tr><tr><td>action_dispatch.request.unsigned_session_cookie</td><td>{"session_id"=&gt;"d1cc25db5c1c9c26bee44fc26bf0db33"}</td></tr><tr><td>action_dispatch.request_id</td><td>0348f929bfb0d81ad30f8f9d6e4ee3e4</td></tr><tr><td>action_dispatch.routes</td><td>#&lt;ActionDispatch::Routing::RouteSet:0x00000100d9de50&gt;</td></tr><tr><td>action_dispatch.secret_token</td><td>fa25a3ca2467cbf83532ee1e4ba3910a24d38e43330d61b13348aeb7ec4adddaff48099288c0534a13bc20425a89227e9e4d25d8772d4abbd02458311140781b</td></tr><tr><td>action_dispatch.show_detailed_exceptions</td><td>true</td></tr><tr><td>action_dispatch.show_exceptions</td><td>true</td></tr><tr><td>rack.errors</td><td>#&lt;IO:0x000001008e3158&gt;</td></tr><tr><td>rack.input</td><td>#&lt;StringIO:0x000001012d3de8&gt;</td></tr><tr><td>rack.multiprocess</td><td>false</td></tr><tr><td>rack.multithread</td><td>false</td></tr><tr><td>rack.request.cookie_hash</td><td>{}</td></tr><tr><td>rack.request.query_hash</td><td>{}</td></tr><tr><td>rack.request.query_string</td><td></td></tr><tr><td>rack.run_once</td><td>false</td></tr><tr><td>rack.session</td><td>{"session_id"=&gt;"d1cc25db5c1c9c26bee44fc26bf0db33", "_csrf_token"=&gt;"sY7knthPDfnRYw0Njbr42fyOxUnqF2vbCxL1av4VCxE="}</td></tr><tr><td>rack.session.options</td><td>{:path=&gt;"/", :domain=&gt;nil, :expire_after=&gt;nil, :secure=&gt;false, :httponly=&gt;true, :defer=&gt;false, :renew=&gt;false, :secret=&gt;"9cd4a176beaafdc9012bebda444a8aee15ee4432e66ccfc770dfe6f7c40a", :coder=&gt;#&lt;Rack::Session::Cookie::Base64::Marshal:0x00000103081700&gt;, :id=&gt;"d1cc25db5c1c9c26bee44fc26bf0db33"}</td></tr><tr><td>rack.url_scheme</td><td>http</td></tr><tr><td>rack.version</td><td>[1, 1]</td></tr></tbody>
          </table>
</div>
            </fieldset>
            <fieldset id="queries_debug_info" style="display: none">
              <legend>Queries</legend>
              <div>            <b id="qtitle_0">            SELECT</b> (<a href="javascript:Footnotes.toggle('qtrace_0')" style="color:#00A;">trace</a>)<br />
            <span id="sql_0"> SELECT COUNT(*) FROM pg_class c LEFT JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind in ('v','r') AND c.relname = 'images' AND n.nspname = ANY (current_schemas(false)) </span><br />
            <span style='background-color:#ffffff'>SCHEMA (0.107ms)</span>&nbsp;
            <p id="qtrace_0" style="display:none;"><a href="txmt://open?url=file:///Users/dstutzman/Documents/dev/2013-q2-rails-1/339/app/views/main/form.html.erb&amp;amp;line=9&amp;amp;column=1">app/views/main/form.html.erb:9:in `_app_views_main_form_html_erb__1302495264472267650_2158916560'</a><br /><a href="txmt://open?url=file:///Users/dstutzman/Documents/dev/2013-q2-rails-1/339/app/controllers/main_controller.rb&amp;amp;line=3&amp;amp;column=1">app/controllers/main_controller.rb:3:in `form'</a><br /></p><br />
            <b id="qtitle_1">SELECT</b> (<a href="javascript:Footnotes.toggle('qtrace_1')" style="color:#00A;">trace</a>)<br />
            <span id="sql_1">SELECT "images".* FROM "images" ORDER BY id</span><br />
            <span style='background-color:#ffffff'>Image Load (0.048ms)</span>&nbsp;
            <p id="qtrace_1" style="display:none;"><a href="txmt://open?url=file:///Users/dstutzman/Documents/dev/2013-q2-rails-1/339/app/views/main/form.html.erb&amp;amp;line=9&amp;amp;column=1">app/views/main/form.html.erb:9:in `_app_views_main_form_html_erb__1302495264472267650_2158916560'</a><br /><a href="txmt://open?url=file:///Users/dstutzman/Documents/dev/2013-q2-rails-1/339/app/controllers/main_controller.rb&amp;amp;line=3&amp;amp;column=1">app/controllers/main_controller.rb:3:in `form'</a><br /></p><br />
            <b id="qtitle_2">UNKNOWN</b> (<a href="javascript:Footnotes.toggle('qtrace_2')" style="color:#00A;">trace</a>)<br />
            <span id="sql_2">EXPLAIN SELECT "images".* FROM "images" ORDER BY id</span><br />
            <span style='background-color:#ffffff'>EXPLAIN (0.001ms)</span>&nbsp;
            <p id="qtrace_2" style="display:none;"><a href="txmt://open?url=file:///Users/dstutzman/Documents/dev/2013-q2-rails-1/339/app/views/main/form.html.erb&amp;amp;line=9&amp;amp;column=1">app/views/main/form.html.erb:9:in `_app_views_main_form_html_erb__1302495264472267650_2158916560'</a><br /><a href="txmt://open?url=file:///Users/dstutzman/Documents/dev/2013-q2-rails-1/339/app/controllers/main_controller.rb&amp;amp;line=3&amp;amp;column=1">app/controllers/main_controller.rb:3:in `form'</a><br /></p><br />
</div>
            </fieldset>
            <fieldset id="log_debug_info" style="display: none">
              <legend>Log</legend>
              <div></div>
            </fieldset>
            <fieldset id="general_debug_info" style="display: none">
              <legend>General (id="general_debug_info")</legend>
              <div>You can use this tab to debug other parts of your application, for example Javascript.</div>
            </fieldset>

          <script type="text/javascript">
            var Footnotes = function() {

              function hideAll(){
Footnotes.hide(document.getElementById('session_debug_info'));
Footnotes.hide(document.getElementById('cookies_debug_info'));
Footnotes.hide(document.getElementById('params_debug_info'));
Footnotes.hide(document.getElementById('filters_debug_info'));
Footnotes.hide(document.getElementById('routes_debug_info'));
Footnotes.hide(document.getElementById('env_debug_info'));
Footnotes.hide(document.getElementById('queries_debug_info'));
Footnotes.hide(document.getElementById('log_debug_info'));
Footnotes.hide(document.getElementById('general_debug_info'));

              }

              function hideAllAndToggle(id) {
                hideAll();
                toggle(id)

                location.href = '#footnotes_debug';
              }

              function toggle(id){
                var el = document.getElementById(id);
                if (el.style.display == 'none') {
                  Footnotes.show(el);
                } else {
                  Footnotes.hide(el);
                }
              }

              function show(element) {
                element.style.display = 'block'
              }

              function hide(element) {
                element.style.display = 'none'
              }

              return {
                show: show,
                hide: hide,
                toggle: toggle,
                hideAllAndToggle: hideAllAndToggle
              }
            }();
            /* Additional Javascript */
            
          </script>
        </div>
!)
        response.body.push '<!-- End Footnotes -->'
        response.body.push html_for_instance_variables
        response.body.push html_for_params
      end
    end
  end

  register Footnotes
end
