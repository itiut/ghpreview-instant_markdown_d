module GHPreview
  module InstantMarkdownD
    class Viewer

      def self.open_url(host, port)
        `xdg-open http://#{host}:#{port}/`
      end

    end
  end
end
