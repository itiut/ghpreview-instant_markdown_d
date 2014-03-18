require 'rack/request'
require 'rack/response'
require 'eventmachine'
require 'ghpreview/converter'

require_relative 'sender'

module GHPreview
  module InstantMarkdownD
    class Server

      def self.run(host, port)
        Sender.setup
        Rack::Handler::Thin.run new, Host: host, Port: port
      end

      def call(env)
        if Sender.request? env
          puts 'connetion establish!'

          Sender.response env

        else
          req = Rack::Request.new(env)

          case req.request_method
          when 'GET'
            Rack::Response.new(Wrapper.wrap_html nil).finish

          when 'PUT'
            EM.defer do
              md = req.body.read
              html = Converter.to_html md
              Sender.send html, :preview
            end

            [200, {}, []]

          when 'DELETE'
            EM.add_timer(1) do
              Sender.send 'die', :die
              Process.kill('TERM', Process.pid)
            end

            [200, {}, []]

          end

        end
      end

    end
  end
end
