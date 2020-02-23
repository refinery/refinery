# frozen_string_literal: true

require 'pathname'
require 'dry/system/components'
require 'dry/system/container'
require 'i18n'

module Refinery
  class Container < Dry::System::Container
    configure do |config|
      config.root = File.expand_path('..', __dir__)
      config.default_namespace = 'refinery'

      config.auto_register = 'lib'
    end

    load_paths! 'lib'

    ::I18n.load_path << Dir[config.root.join('config', 'locales', '*.yml')]
  end
end
