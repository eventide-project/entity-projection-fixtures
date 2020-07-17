# EntityProjection Fixtures

[TestBench](http://test-bench.software/) fixtures for the [EntityProjection](https://github.com/eventide-project/entity-projection) library

The EntityProjection Fixtures library provides [TestBench test fixtures](http://test-bench.software/user-guide/fixtures.html) for testing objects that are implementations of Eventide's [EntityProjection](http://docs.eventide-project.org/user-guide/projection.html). The projection test abstractions simplify and generalize projection tests, reducing the test implementation effort and increasing test implementation clarity.

## Fixtures

A fixture is a pre-defined, reusable test abstraction. The objects under test are specified at runtime so that the same standardized test implementation can be used against multiple objects.

A fixture is just a plain old Ruby object that includes the TestBench API. A fixture has access to the same API that any TestBench test would. By including the `TestBench::Fixture` module into a Ruby object, the object acquires all of the methods available to a test script, including context, test, assert, refute, assert_raises, refute_raises, and comment.

## License

The `entity-projection-fixtures` library is released under the [MIT License](https://github.com/eventide-project/entity-projection-fixtures/blob/master/MIT-License.txt).
