require_relative 'interactive_init'

context "Fixture" do
  fixture(
    EntityProjection::Fixture,
    EntityProjection::Fixture::Controls::Projection::Example,
    EntityProjection::Fixture::Controls::Entity.example,
    EntityProjection::Fixture::Controls::Event.example
  ) do |fixture|

    fixture.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    fixture.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
    fixture.assert_transformed_and_copied(:processed_time => :updated_time) { |v| Time.parse(v) }
  end
end
