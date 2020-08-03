module EntityProjection
  module Fixtures
    module Controls
      module Entity
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
