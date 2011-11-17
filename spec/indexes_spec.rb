require './spec/spec_helper'

describe Indexes do
  let(:the_class) {Indexes}
  let(:the_instance){Indexes.new()}

  describe "Class Methods" do
    it '##list exposes @@list '
    it '##build calls :new and :build'
  end

  describe "Instance Methods" do
    it '#build calls :build on everything in @@list'
    it '#contents calls :to_hash on everything in @@list'
    it '#contents merges @@list hashes into itself'
  end

  describe "The Big Picture" do
    it 'calls build on all including classes from build'
    it 'calls contents on all including classes from contents' 
  end

  describe "Subclasses" do
   it 'keeps its own @@list separate from parent'
  end

end
