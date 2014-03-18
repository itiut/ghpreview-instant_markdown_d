require 'faye/websocket'

module GHPreview
  module InstantMarkdownD
    class Sender

      def self.setup
        Faye::WebSocket.load_adapter('thin')
      end

    end
  end
end
