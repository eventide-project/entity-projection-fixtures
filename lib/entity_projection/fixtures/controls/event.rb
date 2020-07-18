module EntityProjection
  module Fixtures
    module Controls
      module Event
        def self.example
          example = Example.new

          example.example_id = example_id
          example.amount = 11
          example.time = Time::Effective.example
          example.processed_time = Time::Processed.example

          example
        end

        def self.example_id
          Entity.id
        end

        def self.amount
          11
        end

        class Example
          include Messaging::Message

          attribute :example_id, String
          attribute :amount, Numeric, default: 0
          attribute :time, String
          attribute :processed_time, String
        end
      end
    end
  end
end
