require_relative 'interactive_init'

context "Fixture" do
  fixture(
    Projection,
    Controls::Projection::Example,
    Controls::Entity.example,
    Controls::Event.example
  ) do |fixture|

    fixture.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    fixture.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
    fixture.assert_transformed_and_copied(:processed_time => :updated_time) { |v| Time.parse(v) }
  end
end
