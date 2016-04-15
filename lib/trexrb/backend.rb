require 'rails-i18n'

module Trexrb
  class Backend < I18n::Backend::KeyValue
    include I18n::Backend::Memoize

    def initialize
      super(Trexrb.store)
    end
  end
end
