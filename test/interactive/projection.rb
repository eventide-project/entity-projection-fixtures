require_relative 'interactive_init'

context "Projection" do
  entity = Controls::Entity::New.example
  control_entity = Controls::Entity::New.example

  event = Controls::Event.example

  detail "Event: #{event.pretty_inspect}"
  detail "Control Entity: #{control_entity.pretty_inspect}"

  fixture = Projection.build(
    Controls::Projection::Example,
    entity,
    event
  )

  fixture.()

  detail "Applied Entity: #{entity.pretty_inspect}"

  context "Entity is Mutated" do
    test "ID" do
      refute(entity.id == control_entity.id)
    end

    test "Amount" do
      refute(entity.amount == control_entity.amount)
    end

    test "Time" do
      refute(entity.time == control_entity.time)
    end

    test "Other Time" do
      refute(entity.updated_time == control_entity.updated_time)
    end
  end

  context "Event State is Applied to the Entity State" do
    test "ID" do
      assert(entity.id == event.example_id)
    end

    test "Amount" do
      assert(entity.amount == event.amount)
    end

    test "Time" do
      assert(entity.time == Time.parse(event.time))
    end

    test "Some Time => Other Time" do
      assert(entity.updated_time == Time.parse(event.processed_time))
    end
  end
end
