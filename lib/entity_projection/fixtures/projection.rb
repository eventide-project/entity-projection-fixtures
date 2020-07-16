module EntityProjection
  module Fixtures
    class Projection
      include TestBench::Fixture
      include Initializer

      initializer :projection, :entity, :event

      def self.build(projection, entity, event)
        new(projection, entity, event)
      end

      def call

        projection.(entity, event)
      end
    end
  end
end
