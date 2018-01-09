class DummyResourceB
  include ActiveTriples::RDFSource
  configure :type => RDF::URI('http://example.org/type/ResourceB'), repository: :default
  property :label, :predicate => RDF::URI('http://example.org/ontology/label')
  property :in_resource, :predicate => RDF::URI('http://example.org/ontology/in_resource'), :class_name => DummyResourceA
  property :has_resource, :predicate => RDF::URI('http://example.org/ontology/has_resource'), :class_name => DummyResourceC
end
