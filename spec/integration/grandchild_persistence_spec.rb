# frozen_string_literal: true

require 'spec_helper'

autoload :DummyResourceA, 'integration/dummies/dummy_resource_a'
autoload :DummyResourceB, 'integration/dummies/dummy_resource_b'
autoload :DummyResourceC, 'integration/dummies/dummy_resource_c'

describe 'Grandchild persistence' do
  before(:all) do
    ActiveTriples::Repositories.add_repository :default, RDF::Repository.new
  end

  before(:each) do
    b.has_resource = c
    a.has_resource = b
    a.persist!
  end

  let(:a) do
    a = DummyResourceA.new(RDF::URI('http://example.com/a'))
    a.label = 'resource A'
    a
  end

  let(:b) do
    b = DummyResourceB.new(RDF::URI('http://example.com/b'))
    b.label = 'resource B'
    b
  end

  let(:c) do
    c = DummyResourceC.new(RDF::URI('http://example.com/c'))
    c.label = 'resource C'
    c
  end

  describe 'parent resource' do
    subject { DummyResourceA.new(a.id) }

    it { is_expected.to be_persisted }

    it 'has label' do
      expect(subject.label).to eq(a.label)
    end

    describe 'child' do
      subject { DummyResourceA.new(a.id).has_resource }

      it { is_expected.to eq([b]) }

      it 'is persisted' do
        expect(subject.first).to be_persisted
      end

      it 'has label' do
        expect(subject.first.label).to eq(b.label)
      end
    end

    describe 'grandchild through child' do
      subject { DummyResourceA.new(a.id).has_resource.first.has_resource }

      it { is_expected.to eq([c]) }

      it 'is persisted' do
        expect(subject.first).to be_persisted
      end

      it 'has label' do
        expect(subject.first.label).to eq(c.label)
      end
    end
  end

  describe 'child resource' do
    subject { DummyResourceB.new(b.id) }

    it { is_expected.to be_persisted }

    it 'has label' do
      expect(subject.label).to eq(b.label)
    end

    it 'has grandchild resource' do
      expect(subject.has_resource).to eq([c])
    end
  end

  describe 'grandchild resource' do
    subject { DummyResourceC.new(c.id) }

    it { is_expected.to be_persisted }

    it 'has label' do
      expect(subject.label).to eq(c.label)
    end
  end
end
