require_relative 'automated_init'

context "Fixture" do
  entity = Projection::Controls::Entity::New.example
  projection = Projection::Controls::Projection::Example.build(entity)
  event = Projection::Controls::Event.example

  fixture = Projection.build(
    projection,
    event
  ) do |fixture|

    fixture.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    fixture.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
    fixture.assert_transformed_and_copied(:processed_time => :updated_time) { |v| Time.parse(v) }
  end

  fixture.()

  context "Attributes Copied" do
    ['example_id => id', 'amount'].each do |attribute_name|
      context attribute_name do
        passed = fixture.test_session.test_passed?(attribute_name)

        test "Passed" do
          assert(passed)
        end
      end
    end
  end

  context 'Transformed and Copied' do
    ['time', 'processed_time => updated_time'].each do |attribute_name|
      context attribute_name do
        passed = fixture.test_session.test_passed?('Transformed and Copied', attribute_name)

        test "Passed" do
          assert(passed)
        end
      end
    end
  end
end
