# frozen_string_literal: true

require 'dry/matcher'
require 'dry/matcher/result_matcher'
require 'dry/monads/result'

module Refinery
  module Operations
    class Update
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include Dry::Monads::Result::Mixin

      def call(id, attributes)
        validation = form.call(permitted_attributes(attributes))

        if validation.success?
          Success(commit(id, validation))
        else
          Failure(validation)
        end
      end

      private

      def commit(id, validation)
        repo.find(id).changeset(:update, validation.to_h).commit
      end

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
