# frozen_string_literal: true

require_relative 'routes/resolver'

module Refinery
  module Routes
    def self.included(*)
      raise 'include Refinery.Routes instead of Refinery::Routes'
    end

    class Module < ::Module
      # rubocop:disable Metrics/MethodLength
      def initialize(resolver_class)
        singleton_class.define_method :included do |base|
          base.route do |r|
            resolver ||= resolver_class.new(self, route: r)

            resolver.new_action

            resolver.with_key do |key|
              resolver.edit_action(key)
              resolver.delete_action(key)
              resolver.update_action(key)
              r.is do
                resolver.show_action(key)
              end
            end

            r.is do
              resolver.index_action
              resolver.create_action
            end
          end
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end

  # rubocop:disable Naming/MethodName
  def self.Routes(resolver: Routes::Resolver)
    Routes::Module.new(resolver)
  end
  # rubocop:enable Naming/MethodName
end
