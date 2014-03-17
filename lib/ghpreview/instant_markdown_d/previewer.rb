require 'eventmachine'

require_relative 'server'
require_relative 'viewer'
require_relative 'wrapper'

module GHPreview
  module InstantMarkdownD
    class Previewer
      HOST = '127.0.0.1'
      PORT = 8090

      def initialize
        Wrapper.generate_template_with_fingerprinted_stylesheet_links

        EM.defer do
          Viewer.open_url HOST, PORT
        end

        Server.run HOST, PORT
      end

    end
  end
end
