module EntityProjection
  class Fixture
    module Controls
      module Entity
        def self.example
          some_entity = Example.build

          some_entity.id = id
          some_entity.amount = amount
          some_entity.time = Time::Effective::Raw.example
          some_entity.updated_time = Time::Processed::Raw.example

          some_entity
        end

        def self.id
          ID.example(increment: id_increment)
        end

        def self.id_increment
          11
        end

        def self.amount
          1
        end

        class Example
          include Schema::DataStructure

          attribute :id, String
          attribute :amount, Numeric, default: 0
          attribute :time, ::Time
          attribute :updated_time, ::Time
        end

        module New
          def self.example
            Entity::Example.new
          end
        end
      end
    end
  end
end
