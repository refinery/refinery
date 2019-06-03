# frozen_string_literal: true

require 'pathname'
require 'dry/system/components'
require 'dry/system/container'
require 'i18n'

module Refinery
  class Container < Dry::System::Container
    configure do |config|
      config.root = Pathname(File.expand_path('../../', __dir__)).freeze
      config.default_namespace = 'refinery'
      # config.auto_register = %w[lib]
    end

    load_paths! 'lib'

    ::I18n.load_path << Dir[config.root.join('config', 'locales', '*.yml')]
  end
end
