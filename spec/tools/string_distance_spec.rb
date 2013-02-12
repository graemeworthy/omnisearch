require './spec/spec_helper'

describe OmniSearch::StringDistance do
  let(:the_class) {OmniSearch::StringDistance}

  it 'takes two arguments' do
    StringDistance.new('a', 'b')
  end

  describe 'input variables' do
    subject {StringDistance.new('a', 'b')}

    it 'calls one the query' do
      subject.query.should == 'a'
    end

    it 'calls the other the reference' do
      subject.reference.should == 'b'
    end
  end

  describe 'normalization/cleaning of inputs' do
    subject {StringDistance.new('A Query String ', 'A reference sTring')}

    it {should respond_to :clean_string}

    describe '#clean_string' do

      it 'should downcase a string' do
        subject.clean_string("UPPERCASE THING").should == 'uppercase thing'
      end

      it 'should strip surrounding whitespaces' do
        subject.clean_string(' what a mess  ').should == 'what a mess'
      end
    end

    its(:query) {should eq 'a query string'}
    its(:reference) {should eq 'a reference string'}

  end

  describe 'splitting input strings' do
    subject {
      StringDistance.new(
        'hark it doth be a query',
        'avast ye scurvy reference'
      )
    }

    describe '#query_words' do
      it 'should be the query, split into single words' do
        expected = ['hark', 'it', 'doth', 'be', 'a', 'query']
        subject.query_words.should == expected
      end
    end

    describe '#reference_words' do
      it 'should be the reference, split into single words' do
        expected = ['avast', 'ye', 'scurvy', 'reference']
        subject.reference_words.should == expected
      end
    end
  end

  describe 'scoring' do
    subject {StringDistance.new('A Query String ', 'A reference sTring')}
    let(:null_score ) {the_class::NULL_SCORE}

    it {should respond_to :score}

    it 'should return a score from #score' do
      subject.score.should be_a Float
    end

    it 'should return a null score on a blank query input' do
      an_instance = the_class.new('', 'something')
      an_instance.score.should == null_score
    end

    it 'should return a null score on a blank reference input' do
      an_instance = the_class.new('something', '')
      an_instance.score.should == null_score
    end

    it 'should return a non null score on valid input' do
      an_instance = the_class.new('good things', 'good stuff')
      an_instance.score.should_not == null_score
    end

    it 'a good match should have a higher score than a bad match' do
      good_match = the_class.score('queen bee', 'queen beer')
      bad_match  = the_class.score('quarn baa', 'queen beer')
      good_match.should > bad_match
    end
  end

  describe 'word score' do

    describe '#word_position_penality' do
      subject { the_class.new('query', 'reference') }

      it 'should take two integers as arguments' do
        subject.word_position_penalty(1, 2)
      end

      it 'should be the same penality up and down' do
        up = subject.word_position_penalty(1, 2)
        down = subject.word_position_penalty(2, 1)
        up.should == down
      end

      it 'should be a 0 penalty for same' do
        subject.word_position_penalty(1, 1).should == 0
      end
    end

  end


end

