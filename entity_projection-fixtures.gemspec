# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'evt-entity_projection-fixtures'
  s.summary = 'TestBench fixtures for EntityProjection implementations'
  s.version = '1.0.0.2'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/entity-projection-fixtures'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'evt-entity_projection'
  s.add_runtime_dependency 'evt-schema-fixtures'

  s.add_development_dependency 'test_bench'
end
