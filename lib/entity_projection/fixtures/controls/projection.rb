module EntityProjection
  module Fixtures
    module Controls
      module Projection
        class Example
          include ::EntityProjection

          entity_name :example

          apply Event::Example do |event|
            example.id = event.example_id
            example.amount = event.amount
            example.time = ::Time.parse(event.time)
          end
        end
      end
    end
  end
end
