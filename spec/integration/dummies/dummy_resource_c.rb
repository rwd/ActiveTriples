class DummyResourceC
  include ActiveTriples::RDFSource
  configure :type => RDF::URI('http://example.org/type/ResourceC'), repository: :default
  property :label, :predicate => RDF::URI('http://example.org/ontology/label')
  property :in_resource, :predicate => RDF::URI('http://example.org/ontology/in_resource'), :class_name => DummyResourceB
end
