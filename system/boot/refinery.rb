# frozen_string_literal: true

Refinery::Container.boot :refinery do
  init do
    require 'refinery/assets'
    require 'refinery/extension_manager'
    require 'refinery/routes'
    require 'refinery/web'
  end

  start do
    register :extension_manager, Refinery::ExtensionManager.new
  end
end
