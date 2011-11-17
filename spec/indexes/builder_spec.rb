require './spec/spec_helper'

describe Indexes::Builder do
  let(:the_method) {Indexes::Builder}
  it 'exists to hold things'
end

describe Indexes::Builder::Plain do
  let(:the_class) {Indexes::Builder::Plain}
  let(:the_instance){Indexes::Builder::Plain.new}

  describe "Constants" do
    it 'STORAGE_ENGINE should be a storage engine'
    it 'MASTER_INDEX should be a master index'
  end

  describe "Including" do
    it 'adds itself to some Index#list when included'
  end

  describe "Added Methods" do
    it '#file, holds a storage engine'
    it '#build_records applies the record_template to the collection'
    it '#build saves all records to storage'
    it '#load retrieves a set of records from storage'
    it '#load raises unless that file exists'
    it '#records memoizes #load'
  end

  describe "Required Implementations" do
    it 'raises unless #index_name is defined'
    it 'raises unless #collection is defined'
    it 'raises unless #record_templete is defined'
  end

  describe "Subclasses" do
   it 'can be included in a class'
   it 'keeps its own @@list separate from parent'
  end

  describe "The Big Picture" do
    it '#build, saves all of the recods to a file'
    it '#load, loads all of the recods from a file'
    it '#to_hash, returns a clean hash of all the recods with :index_name, as the key'    
  end

end


