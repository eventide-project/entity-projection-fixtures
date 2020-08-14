module EntityProjection
  module Fixtures
    class Projection
      include TestBench::Fixture
      include Initializer

      def entity_class
        entity.class
      end

      def event_class
        event.class
      end

      initializer :projection, :control_entity, :entity, :event, :test_block

      def self.build(projection, event, &test_block)
        entity = projection.entity
        control_entity = entity.clone

        new(projection, control_entity, entity, event, test_block)
      end

      def call
        projection_type = projection.class.name.split('::').last
        entity_type = entity.class.name.split('::').last
        event_type = event.message_type

        detail "Projection Class: #{projection.class.name}"

        context "Apply #{event.message_type} to #{entity.class.type}" do

          detail "Event Class: #{event.class.name}"
          detail "Entity Class: #{entity.class.name}"

          projection.(event)

          if not test_block.nil?
            test_block.call(self)
          end
        end
      end

      def assert_attributes_copied(attribute_names=nil)
        fixture(
          Schema::Fixtures::Equality,
          event,
          entity,
          attribute_names,
          ignore_class: true,
          print_title_context: false,
          attributes_context_name: 'Copied'
        )
      end

      def assert_transformed_and_copied(attribute_name, &transform)
        if attribute_name.is_a?(Hash)
          event_attribute_name = attribute_name.keys.first
          entity_attribute_name = attribute_name.values.first
        else
          event_attribute_name = attribute_name
          entity_attribute_name = attribute_name
        end

        event_attribute_value = event.public_send(event_attribute_name)
        entity_attribute_value = entity.public_send(entity_attribute_name)

        context "Transformed and Copied" do
          detail "#{event_class.name.split('::').last} Value (#{event_attribute_value.class.name}): #{event_attribute_value.inspect}"
          detail "#{entity_class.name.split('::').last} Value (#{entity_attribute_value.class.name}): #{entity_attribute_value.inspect}"

          printed_attribute_name = self.class.printed_attribute_name(event_attribute_name, entity_attribute_name)

          transformed_event_value = transform.call(event_attribute_value)

          test printed_attribute_name do
            assert(transformed_event_value == entity_attribute_value)
          end
        end
      end

      def self.printed_attribute_name(event_time_attribute, entity_time_attribute)
        if event_time_attribute == entity_time_attribute
          return event_time_attribute.to_s
        else
          return "#{event_time_attribute} => #{entity_time_attribute}"
        end
      end
    end
  end
end
