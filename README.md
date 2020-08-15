# EntityProjection Fixtures

The EntityProjection Fixtures library provides a [TestBench test fixture](http://test-bench.software/user-guide/fixtures.html) for testing objects that are implementations of Eventide's [EntityProjection](http://docs.eventide-project.org/user-guide/projection.html). The projection test abstraction simplifies and generalizes projection tests, reducing the test implementation effort and increasing test implementation clarity.

## Fixture

A fixture is a pre-defined, reusable test abstraction. The objects under test are specified at runtime so that the same standardized test implementation can be used against multiple objects.

A fixture is just a plain old Ruby object that includes the TestBench API. A fixture has access to the same API that any TestBench test would. By including the `TestBench::Fixture` module into a Ruby object, the object acquires all of the methods available to a test script, including context, test, assert, refute, assert_raises, refute_raises, and comment.

## Projection Fixture

The `EntityProjection::Fixtures::Projection` fixture tests the projection of events onto an entity. It tests that the attributes of an event are copied to the entity. The attributes tested can be limited to a subset of attributes by specifying a list of attribute names. A map can be provided to compare attributes that have a different name on the source event than on the entity. The projection fixture also allows the testing of values copied from an event that are transformed before being assigned to an entity's attributes. The copy-and-transform assertion can also accept a map to test the transformation between attributes that have a different name on the source event than on the entity.

``` ruby
class SomeEntity
  include Schema::DataStructure

  attribute :id, String
  attribute :amount, Numeric, default: 0
  attribute :time, ::Time
  attribute :other_time, ::Time
end

class SomeEvent
  include Messaging::Message

  attribute :example_id, String
  attribute :amount, Numeric, default: 0
  attribute :time, String
  attribute :some_time, String
end

class SomeProjection
  include EntityProjection

  entity_name :some_entity

  apply SomeEvent do |some_event|
    some_entity.id = some_event.example_id
    some_entity.amount = some_event.amount
    some_entity.time = Time.parse(some_event.time)
    some_entity.other_time = Time.parse(some_event.some_time)
  end
end

context "SomeProjection" do
  some_event = SomeEvent.new
  some_event.example_id = SecureRandom.uuid
  some_event.amount = 11
  some_event.time = Time.utc(2000)
  some_event.some_time = Time.utc(2000) + 1

  some_entity = SomeEntity.new
  some_projection = SomeProjection.build(entity)

  fixture(
    EntityProjection::Fixtures::Projection,
    some_projection,
    some_event
  ) do |projection|

    projection.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    projection.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
    projection.assert_transformed_and_copied(:some_time => :other_time) { |v| Time.parse(v) }
  end
end
```

## Running the Fixture

Running the test is no different than [running any TestBench test](http://test-bench.software/user-guide/running-tests.html).

For example, given a test file named `projection.rb` that uses the projection fixture, in a directory named `test`, the test is executed by passing the file name to the `ruby` executable.

``` bash
ruby test/projection.rb
```

The test script and the fixture work together as if they are part of the same test context, preserving output nesting between the test script file and the test fixture.

## Projection Fixture Output

``` text
SomeProjection
  Apply SomeEvent to SomeEntity
    Copied
      example_id => id
      amount
    Transformed and copied
      time
    Transformed and copied
      some_time => other_time
```

The output below the "SomeProjection" line is from the projection fixture.

## Detailed Output

In the event of any error or failed assertion, the test output will include additional detailed output that can be useful in understanding the context of the failure and the state of the fixture itself and the objects that it's testing.

The detailed output can also be printed by setting the `TEST_BENCH_DETAIL` environment variable to `on`.

``` bash
TEST_BENCH_DETAIL=on ruby test/projection.rb
```

``` text
SomeProjection
  Projection Class: SomeProjection
  Apply SomeEvent to SomeEntity
    Event Class: SomeEvent
    Entity Class: SomeEntity
    Attributes
      example_id => id
        SomeEvent Value: "00000001-0000-4000-8000-000000000000"
        SomeEntity Value: "00000001-0000-4000-8000-000000000000"
      amount
        SomeEvent Value: 11
        SomeEntity Value: 11
    Transformed and copied
      time
        SomeEvent Value (String): "2000-01-01T00:00:00.000Z"
        SomeEntity Value (Time): 2000-01-01 00:00:00 UTC
    Transformed and copied
      some_time => other_time
        SomeEvent Value (String): "2000-01-01T00:00:00.011Z"
        SomeEntity Value (Time): 2000-01-01 00:00:00.011 UTC
```

## Actuating the Projection Fixture

The fixture is executed using TestBench's `fixture` method.

``` ruby
fixture(EntityProjection::Fixtures::Projection, projection, event, &test_block)
```

The first argument sent to the `fixture` method is always the `EntityProjection::Fixtures::Projection` class. Subsequent arguments are the specific construction parameters of the projection fixture.

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| projection | Projection instance used to apply the event to the entity | EntityProjection |
| entity | Object to project state into | (any) |
| event | Event to project state from | Messaging::Message |
| test_block | Block evaluated in the context of the fixture used for invoking other assertions that are part of the fixture's API | Proc |

**Block Parameter**

The `projection_fixture` argument is passed to the `test_block` if the block is given.

| Name | Description | Type |
| --- | --- | --- |
| projection_fixture | Instance of the projection fixture that is being actuated | EntityProjection::Fixtures::Projection |

**Block Parameter Methods**

The following methods are available from the `projection_fixture` block parameter, and on an instance of `EntityProjection::Fixtures::Projection`:

- `assert_attributes_copied`
- `assert_transformed_and_copied`

## Testing Attribute Values Copied to the Entity

``` ruby
assert_attributes_copied(attribute_names=[])
```

The `assert_attributes_copied` method tests that attribute values are copied from the event being applied to the entity receiving the attribute data. By default, all attributes from the event are compared to entity attributes of the same name.

An optional list of attribute names can be passed. When the list of attribute names is passed, only those attributes will be compared. The list of attribute names can also contain maps of attribute names for comparing values when the entity attribute name is not the same as the event attribute name.

**Example**

``` ruby
projection.assert_attributes_copied([
  { :example_id => :id },
  :amount
])
```

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| attribute_names | Optional list of attribute names to compare, or maps of event attribute name to entity attribute name | Array of Symbol or Hash |

## Testing Individual Attribute Transformations Copied to the Entity

``` ruby
assert_transformed_and_copied(attribute_name, &transform)
```

A projection may transform or convert the event data that it's assigning to an entity. The `assert_transformed_and_copied` method allows an event attribute to be transformed before being compared to an entity attribute. The assertion can also accept a map to test the transformation between attributes that have a different name on the source event than on the entity.

**Example**

``` ruby
projection.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
projection.assert_transformed_and_copied(:some_time => :other_time) { |v| Time.parse(v) }
```

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| attribute_name | Name of the event attribute to compare, or map of event attribute name to entity attribute name | Symbol or Hash |

## More Documentation

More detailed documentation on the fixtures and their APIs can be found in the test fixtures user guide on the Eventide documentation site:

[http://docs.eventide-project.org/user-guide/test-fixtures/](http://docs.eventide-project.org/user-guide/test-fixtures/)

## License

The Entity Projection Fixtures library is released under the [MIT License](https://github.com/eventide-project/entity-projection-fixtures/blob/master/MIT-License.txt).
