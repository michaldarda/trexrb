require "trexrb/version"
require "trexrb/storage"
require "trexrb/backend"

module Trexrb
  def self.store
    @store ||= Storage.new
  end
end
