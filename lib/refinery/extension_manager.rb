# frozen_string_literal: true

require_relative 'plugin'
require_relative 'plugins'

module Refinery
  class ExtensionManager
    def call(*args)
      Plugin.new(*args).register!
    end

    def registered
      Plugins.registered
    end
  end
end
