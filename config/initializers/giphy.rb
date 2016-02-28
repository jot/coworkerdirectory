module Giphy
  class Gif
    def self.build_batch_from(array_or_hash)
      if array_or_hash.is_a?(Array)
        array_or_hash.map { |gif| new(gif) }
      else
        new(array_or_hash)
      end
    end
  end
end