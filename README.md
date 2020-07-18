# EntityProjection Fixture

[TestBench](http://test-bench.software/) fixture for [EntityProjection](https://github.com/eventide-project/entity-projection) implementations

The EntityProjection Fixture library provides a [TestBench test fixture](http://test-bench.software/user-guide/fixtures.html) for testing objects that are implementations of Eventide's [EntityProjection](http://docs.eventide-project.org/user-guide/projection.html). The projection test abstraction simplifies and generalizes projection tests, reducing the test implementation effort and increasing test implementation clarity.

## Fixture

A fixture is a pre-defined, reusable test abstraction. The objects under test are specified at runtime so that the same standardized test implementation can be used against multiple objects.

A fixture is just a plain old Ruby object that includes the TestBench API. A fixture has access to the same API that any TestBench test would. By including the `TestBench::Fixture` module into a Ruby object, the object acquires all of the methods available to a test script, including context, test, assert, refute, assert_raises, refute_raises, and comment.

## Projection Fixture

The `EntityProjection::Fixture::Projection` fixture tests the projection of an event onto an entity. It tests that the attributes of event are copied to the entity. The attributes tested can be limited to a subset of attributes by specifying a list of attribute names, and a map can be provided to compare different attributes to each other. The projection fixture also allows the testing of time values copied from an event in serialized text format to an entity object's natural time values.

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

  fixture(
    EntityProjection::Fixture::Projection,
    SomeProjection,
    some_entity,
    some_entity
  ) do |fixture|

    fixture.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    fixture.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
    fixture.assert_transformed_and_copied(:some_time => :other_time) { |v| Time.parse(v) }
  end
end
```

Running the test is no different than [running any TestBench test](http://test-bench.software/user-guide/running-tests.html). In its simplest form, running the test is done by passing the test file name to the `ruby` executable.

``` bash
ruby test/projection.rb
```

The test script and the fixture work together as if they are the same test.

```
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

The output from the "SomeProjection" line-downward is from the Equality fixture.

### Detailed Output

The fixture will print more detailed output if the `TEST_BENCH_DETAIL` environment variable is set to `on`.

``` bash
TEST_BENCH_DETAIL=on ruby test/projection.rb
```

```
SomeProjection
  Projection Class: SomeProjection
  Apply SomeEvent to SomeEntity
    Event Class: SomeEvent
    Entity Class: SomeEntity
    Attributes
      example_id => id
        Control Value: "00000001-0000-4000-8000-000000000000"
        Compare Value: "00000001-0000-4000-8000-000000000000"
      amount
        Control Value: 11
        Compare Value: 11
    Transformed and copied
      time
        Event Value (String): "2000-01-01T00:00:00.000Z"
        Entity Value (Time): 2000-01-01 00:00:00 UTC
    Transformed and copied
      some_time => other_time
        Event Value (String): "2000-01-01T00:00:00.011Z"
        Entity Value (Time): 2000-01-01 00:00:00.011 UTC
```

### Projection Fixture API

Class: `EntityProjection::Fixture::Projection`

#### Construct the Projection Fixture

The projection fixture is only ever constructed directly when [testing](http://test-bench.software/user-guide/fixtures.html#testing-fixtures) the fixture. Usually, when the fixture is used to fulfill its purpose of testing a projection, TestBench's `fixture` method is used.

``` ruby
self.build(projection, entity, event, &action)
```

**Returns**

Instance of `EntityProjection::Fixture::Projection`

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| projection | Projection class used to apply the event to the entity | EntityProjection |
| entity | Object to project state into  | (any) |
| event | Event to project state from | Messaging::Message |
| action | Supplemental proc evaluated in the context of the fixture. Used for invoking other assertions that are part of the fixture's API. | Proc |

#### Actuating the Fixture

The projection fixture is only ever actuated directly when [testing](http://test-bench.software/user-guide/fixtures.html#testing-fixtures) the fixture. Usually, when the fixture is used to fulfill its purpose of testing a projection, TestBench's `fixture` method is used.

``` ruby
call()
```

#### Testing Attribute Values

The `assert_attributes_copied` method tests that attribute values are copied from the event being applied to the entity receiving the attribute data. By default, all attributes from the event are compared to entity attributes of the same name. An optional list of attribute names can be passed. WHen the list of attribute names is passed, only those attributes will be compared. The list of attribute names can also contain maps of attribute names for comparing values when the entity attribute name is not the same as the event attribute name.

``` ruby
assert_attributes_copied(attribute_names=[])
```

**Parameters**

| Name | Description | Type | Default |
| --- | --- | --- | --- |
| attribute_names | Optional list of attribute names to limit testing to | Array of Symbol or Hash | Attribute names of left-hand side object |

The `assert_attributes_copied` method is implemented using the `Schema::Fixture::Equality` fixture from the [Schema Fixture library](https://github.com/eventide-project/schema-fixtures).

#### Testing Individual Attribute Transformations

Projects may not just copy attributes from an event to an entity verbatim. A projection might transform or convert the event data that it's assigning to an entity. The `assert_transformed_and_copied` method allows an event attribute to be transformed before being compared to an entity attribute.

``` ruby
assert_time_converted_and_copied(time_attribute_name)
```

**Parameters**

| Name | Description | Type |
| --- | --- | --- |
| attribute_name | Name of the event attribute, or map of event attribute name to entity attribute name, to be compared | Symbol or Hash |

## License

The `entity-projection-fixtures` library is released under the [MIT License](https://github.com/eventide-project/entity-projection-fixtures/blob/master/MIT-License.txt).
