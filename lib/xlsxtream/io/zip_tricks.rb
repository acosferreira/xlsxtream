require "zip_tricks"

module Xlsxtream
  module IO
    class ZipTricks
      BUFFER_SIZE = 64 * 1024

      def initialize(body)
        @streamer = ::ZipTricks::Streamer.new(body)
        @wf = nil
        @buffer = ''
      end

      def <<(data)
        @buffer << data
        flush_buffer if @buffer.size >= BUFFER_SIZE
        self
      end

      def add_file(path)
        flush_file
        @wf = @streamer.write_deflated_file(path)
      end

      def close
        flush_file
        @streamer.close
      end

      private

      def flush_buffer
        @wf << @buffer
        @buffer.clear
      end

      def flush_file
        return unless @wf
        flush_buffer if @buffer.size > 0
        @wf.close
      end
    end
  end
end
