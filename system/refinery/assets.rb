# frozen_string_literal: true

module Refinery
  class Assets
    attr_reader :core, :root, :precompiled, :precompiled_host, :server_url

    def initialize(config:)
      self.core = config.container['core.container']
      self.root = config.container.root
      self.precompiled = config.settings.precompiled_assets
      self.precompiled_host = config.settings.precompiled_assets_host
      self.server_url = config.settings.assets_server_url
    end

    def [](asset)
      if precompiled
        asset_path_from_manifest(asset)
      else
        asset_path_on_server(asset)
      end
    end

    def plugin_css(plugin)
      return nil unless type_exists?('css', plugin)

      self["#{plugin}__#{plugin}.css"]
    end

    def plugin_js(plugin)
      return nil unless type_exists?('js', plugin)

      self["#{plugin}__#{plugin}.js"]
    end

    private

    attr_writer :core, :root, :precompiled, :precompiled_host, :server_url

    def asset_dir(type, plugin)
      "apps/#{plugin}/assets/#{plugin}/#{type}"
    end

    def asset_path_from_manifest(asset)
      "#{precompiled_host}/assets/#{manifest[asset]}" if exists?(asset)
    end

    def asset_path_on_server(asset)
      "#{server_url}/assets/#{asset}"
    end

    def exists?(asset, plugin = '*', type = nil)
      return manifest[asset] if precompiled

      type ||= File.extname(asset).delete('.')
      File.exist?(File.join(asset_dir(type, plugin), asset))
    end

    def type_exists?(type, plugin)
      if precompiled
        manifest.any? { |key, _| key.end_with?("#{plugin}.#{type}") }
      else
        Dir.exist?(asset_dir(type, plugin))
      end
    end

    def manifest
      @manifest ||= YAML.load_file(manifest_path)
    end

    def manifest_path
      Dir["#{core.root}/public/assets/asset-manifest.json"].first
    end
  end
end
