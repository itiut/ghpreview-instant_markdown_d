require 'faye/websocket'

module GHPreview
  module InstantMarkdownD
    class Sender

      def self.setup
        Faye::WebSocket.load_adapter('thin')
      end

      def self.request?(env)
        Faye::EventSource.eventsource?(env)
      end

      def self.response(env)
        @es ||= Faye::EventSource.new(env)
        @es.onclose = lambda { |event| @es = nil }
        @es.rack_response
      end

      def self.send(content, event)
        @es.send(content, event: event.to_s) if @es
      end
    end
  end
end
