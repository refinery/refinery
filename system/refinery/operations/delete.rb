# frozen_string_literal: true

require 'dry/matcher'
require 'dry/matcher/result_matcher'
require 'dry/monads/result'

module Refinery
  module Operations
    class Delete
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      include Dry::Monads::Result::Mixin

      # This is a soft delete..
      def call(id)
        deleted = delete!(id)
        if deleted?(deleted)
          Success(deleted)
        else
          Failure(deleted)
        end
      end

      private

      def delete!(id)
        repo.by_pk(id).delete
      end

      def deleted?(deleted)
        deleted.key?(repo.root.primary_key)
      end

      def repo
        raise NotImplementedError
      end
    end
  end
end
