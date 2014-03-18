module GHPreview
  module InstantMarkdownD
    class Viewer
      def self.open_url(host, port)
        command = if RUBY_PLATFORM =~ /linux/
                    'xdg-open'
                  else
                    'open'
                  end
        `#{command} http://#{host}:#{port}`
      end
    end
  end
end
