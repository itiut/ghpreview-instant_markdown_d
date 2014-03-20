require 'eventmachine'

require_relative 'server'
require_relative 'viewer'
require_relative 'extension/ghpreview/wrapper'

module GHPreview
  module InstantMarkdownD
    class Previewer
      HOST = 'localhost'
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
