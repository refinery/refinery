# frozen_string_literal: true

require 'dry/web/roda/application'
require 'rack/csrf'
require 'rack/method_override'
require_relative 'assets'

module Refinery
  class Web < Dry::Web::Roda::Application
    setting :settings, reader: true

    use Rack::MethodOverride

    plugin :all_verbs
    plugin :dry_view
    plugin :error_handler
    plugin :flash
    plugin :match_affix, nil, %r{(?:/\z|(?=/|\z))}
    plugin :multi_route

    # Request-specific options for dry-view context object
    def view_context_options
      {
        app: self,
        assets: Assets.new(config: self.class.config),
        flash: flash,
        csrf_token: Rack::Csrf.token(request.env),
        csrf_metatag: Rack::Csrf.metatag(request.env),
        csrf_tag: Rack::Csrf.tag(request.env),
        delete_tag: '<input type="hidden" name="_method" value="delete" />',
        patch_tag: '<input type="hidden" name="_method" value="patch" />'
      }
    end
  end
end
