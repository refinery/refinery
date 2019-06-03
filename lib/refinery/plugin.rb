# frozen_string_literal: true

require 'dry/initializer'
require 'i18n'
require 'pathname'
require_relative 'plugins'

module Refinery
  class Plugin
    extend Dry::Initializer

    option :app
    option :name
    option :hide_from_menu, optional: true, default: -> { false }
    option :url
    option :pathname, optional: true, default: -> {
      app.load_paths.find { |path| path.basename.to_s == 'lib' }
    }

    def register!(registry: ::Refinery::Plugins.registered)
      registry.push(self).uniq!(&:name)
    end

    # Returns the internationalized version of the description
    def description
      I18n.translate(['admin', 'plugins', config.name, 'description'].join('.'))
    end

    def landable?
      !config.hide_from_menu &&
        !config.url.nil? &&
        !(config.url.nil? || config.url.empty?)
    end

    def title
      I18n.translate(['admin', 'plugins', name, 'title'].join('.'))
    end
  end
end
