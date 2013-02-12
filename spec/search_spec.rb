require './spec/spec_helper'


describe Search do

  let(:a_result) { Result.new({})}
  let(:the_term)           {'some term'}
  let(:the_correction)     {'some correction'}
  let(:the_class)    {Search}
  let(:the_instance) {Search.new('some term')}


  describe 'Instance Methods' do
    subject {the_instance}
    it {should respond_to :correction}
    it {should respond_to :result_sets}
    it {should respond_to :extended_result_sets}
  end

  describe 'AutoCorrection' do
    it 'should look for a correction in AutoCorrect' do
      AutoCorrect.should_receive(:for).with(the_term)
      Search.new(the_term)
    end

    it 'should return a Correction if there is one' do
      AutoCorrect.add(the_term, the_correction)
      the_instance.correction.should be_a Correction
    end

    it 'should store the original in @original' do
      the_instance.original.should == the_term
    end

    it 'should update @term' do
      the_instance.term.should == the_correction
    end

    it 'should return nil if there is not' do
      AutoCorrect.remove('some term')
      the_instance.correction.should be nil
    end
  end

  describe 'Result Sets' do
    it 'should return an array for result_sets' do
      the_instance.result_sets.should be_an Array
    end

    it 'should return an array for extended_result_sets' do
      the_instance.extended_result_sets.should be_an Array
    end
  end

  describe 'Just' do
    it 'should be able to get "just" one index' do
      class SomeIndexClass; end;
      class SomeOtherIndexClass; end;

      wanted = ResultSet.new(SomeIndexClass, [a_result])
      not_wanted = ResultSet.new(SomeOtherIndexClass, [a_result])
      fake_results = [wanted, not_wanted]
      the_instance.result_sets = fake_results
      the_instance.just(SomeIndexClass).should == wanted
    end
  end

  describe 'Running a Strategy' do
    it 'calls Search::Strategy.run  with @term' do
      Search::Strategy.should_receive(:run).with(the_term).and_return([])
      Search.new(the_term)
    end
  end

  describe 'Top and Extended Results' do
    let(:dummy_results) {['an array of', 'something']}

    before do
      Search::Strategy.stub(:run) {dummy_results}
    end

    it 'if there are any results, call extended and top results' do
      ResultSet::Extended.should_receive(:find).with(dummy_results)
      ResultSet::Top.should_receive(:find).with(dummy_results)

      Search.new(the_term)
    end

    it 'put the return value of top results, on top' do
      top_dummy = ['i am first']
      ResultSet::Extended.should_receive(:find).with(dummy_results)
      ResultSet::Top.should_receive(:find).
        with(dummy_results).
        and_return(top_dummy)
      Search.new(the_term).result_sets.first.should be top_dummy

    end
  end

end
