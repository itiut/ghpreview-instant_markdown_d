require 'rack/request'
require 'rack/response'
require 'faye/websocket'
require 'eventmachine'
require 'ghpreview/converter'

module GHPreview
  module InstantMarkdownD
    class Server

      def self.run(host, port)
        Faye::WebSocket.load_adapter('thin')
        Rack::Handler::Thin.run Server.new, :Host => host, :Port => port
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
            Rack::Response.new(Wrapper.wrap_html nil).finish

          when 'PUT'
            EM.defer do
              md = req.body.read
              html = Converter.to_html md
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
