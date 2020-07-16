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

    fixture.assert_time_converted_and_copied(:time, :time)
  end
end
