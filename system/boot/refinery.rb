# frozen_string_literal: true

Refinery::Container.boot :refinery do
  init do
    require 'refinery/assets'
    require 'refinery/plugin'
    require 'refinery/plugins'
    require 'refinery/routes'
    require 'refinery/web'
  end

  start do
    register :plugin, Refinery::Plugin
    register :plugins, Refinery::Plugins.registered
  end
end
