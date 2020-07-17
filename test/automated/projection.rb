require_relative 'automated_init'

context "Projection" do
  fixture = Projection.build(
    Controls::Projection::Example,
    Controls::Entity.example,
    Controls::Event.example
  ) do |fixture|

    fixture.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    fixture.assert_time_converted_and_copied(:time)
    fixture.assert_time_converted_and_copied(:some_time => :other_time)
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

  context 'Time Converted and Copied' do
    ['time', 'some_time => other_time'].each do |attribute_name|
      context attribute_name do
        passed = fixture.test_session.test_passed?('Time converted and copied', attribute_name)

        test "Passed" do
          assert(passed)
        end
      end
    end
  end
end

__END__

Fixture
  Apply Example to Example
    Schema Equality: Example, Example
      Attributes
        example_id => id
        amount
    Time converted and copied
      time
    Time converted and copied
      some_time => other_time
