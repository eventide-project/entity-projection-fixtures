puts RUBY_DESCRIPTION

puts
puts "TEST_BENCH_DETAIL: #{ENV['TEST_BENCH_DETAIL'].inspect}"
puts

require_relative '../init.rb'
require 'entity_projection/fixtures/controls'

require 'pp'

require 'test_bench'; TestBench.activate

include EntityProjection::Fixtures

def prn(object, description=nil)
  *, namespace, name = object.class.name.split('::')

  if description.nil?
    output = "#{namespace}::#{name}"
  else
    output = "(#{description}) #{namespace}::#{name}"
  end

  puts
  puts output
  puts '- - -'
  pp object
end
