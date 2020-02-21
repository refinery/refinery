# frozen_string_literal: true

require 'dry/matcher'
require 'dry/matcher/result_matcher'
require 'dry/monads/result'

module Refinery
  module Operations
    class Create
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include Dry::Monads::Result::Mixin

      def call(attributes)
        validation = form.call(permitted_attributes(attributes))

        if validation.success?
          Success(repo.create(validation.to_h))
        else
          Failure(validation)
        end
      end

      private

      def form
        raise NotImplementedError
      end

      def permitted_attributes(attributes)
        attributes
      end

      def repo
        raise NotImplementedError
      end
    end
  end
end
