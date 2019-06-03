# frozen_string_literal: true

require 'dry/core/inflector'
require 'forwardable'
module Refinery
  module Routes
    class Resolver
      extend Forwardable

      attr_accessor :web, :friendly, :node, :route, :route_finder

      def initialize(web, route:, route_finder: nil, node: nil, friendly: nil)
        self.web = web
        self.route_finder = route_finder || method(:root_path)
        self.node = node || Dry::Core::Inflector.underscore(
          Dry::Core::Inflector.singularize(web.class.name.split('::').first)
        ).freeze
        self.friendly = friendly || self.node.to_s.tr('_', ' ').capitalize
        self.route = route
      end

      def_delegators :web, :flash
      alias r route

      def new_action
        r.get 'new' do
          r.view :new
        end
      end

      def create_action
        r.post do
          r.resolve 'operations.create' do |create|
            create.call(r[node]) do |m|
              m.success do
                flash[:notice] = "#{friendly} created"
                r.redirect route_finder.call(r)
              end

              m.failure do |validation|
                r.view :new, validation: validation
              end
            end
          end
        end
      end

      def edit_action(id)
        r.is 'edit' do
          r.get do
            r.view :edit, id: id
          end
        end
      end

      def index_action
        r.get do
          r.view :index, locale: web.request.params['locale']
        end
      end

      def delete_action(id)
        r.delete do
          r.resolve 'operations.delete' do |delete|
            delete.call(id) do |m|
              m.success do
                flash[:notice] = "#{friendly} deleted"
                r.redirect route_finder.call(r)
              end

              m.failure do
                flash[:alert] = "#{friendly} not deleted"
                r.redirect route_finder.call(r)
              end
            end
          end
        end
      end

      def update_action(id)
        r.patch do
          r.resolve 'operations.update' do |update|
            update.call(id, r[node]) do |m|
              m.success do
                flash[:notice] = "#{friendly} updated"
                r.redirect route_finder.call(r)
              end

              m.failure do |validation|
                r.view :edit, id: id, validation: validation
              end
            end
          end
        end
      end

      def with_key
        r.on String do |id|
          yield id
        end
      end

      def show_action(id)
        r.get do
          r.view :show, id: id, locale: web.request.params['locale']
        end
      end

      def root_path(route)
        route.path.sub(route.path_info, '')
      end
    end
  end
end
# rubocop:enable
