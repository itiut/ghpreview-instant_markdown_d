require 'rack/request'
require 'rack/response'
require 'faye/websocket'
require 'eventmachine'
require 'erb'
require 'ghpreview/converter'
require 'httpclient'
require 'ghpreview'

module GHPreview
  module InstantMarkdownD
    class Server
      GITHUB_URL = 'https://github.com'

      class << self
        def run
          Faye::WebSocket.load_adapter('thin')
          Rack::Handler::Thin.run Server.new, :Host => '127.0.0.1', :Port => 8090
        end
      end

      def initialize
        http = HTTPClient.new
        @stylesheet_links = http.get(GITHUB_URL).body.split("\n").select { |line|
          line =~ /https:.*github.*\.css/
        }.join
      end

      def call(env)
        if Faye::EventSource.eventsource?(env)
          @es ||= Faye::EventSource.new(env)

          puts 'connetion establish!'

          @es.onclose = lambda do |event|
            @es = nil
          end

          @es.rack_response

        else
          req = Rack::Request.new(env)

          case req.request_method
          when 'GET'
            template_path = "#{File.dirname(__FILE__)}/template.erb"
            raw_template  = File.read(template_path)
            styled_template = ERB.new(raw_template).result(binding)
            Rack::Response.new(styled_template).finish

          when 'PUT'
            EM.defer do
              md = req.body.read
              html = GHPreview::Converter.to_html md
              @es.send(html, event: 'preview') if @es
            end

            [200, {}, []]

          when 'DELETE'
            EM.add_timer(1) do
              @es.send('die', event: 'die') if @es
              Kernel.exit!
            end

            [200, {}, []]

          end

        end

      end
    end
  end
end
