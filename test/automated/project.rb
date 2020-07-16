require_relative 'automated_init'

context "Entity Mutation" do
  entity = Controls::Entity::New.example
  control_entity = Controls::Entity::New.example

  event = Controls::Event.example

  fixture = Projection.build(
    Controls::Projection::Example,
    entity,
    event
  )

  fixture.()

  detail "Event: #{event.pretty_inspect}"
  detail "Control Entity: #{control_entity.pretty_inspect}"
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
  end

  context "Event State is Applied to the Entity State" do
    test "ID" do
      assert(entity.id == event.example_id)
    end

    test "Amount" do
      assert(entity.amount == event.amount)
    end
  end
end
