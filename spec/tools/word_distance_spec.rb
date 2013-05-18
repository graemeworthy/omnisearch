require './spec/spec_helper'

describe OmniSearch::StringDistance::WordDistance do
  let(:the_class) {OmniSearch::StringDistance::WordDistance}
  subject { the_class.new('query', 'reference') }

  describe 'word score' do
    def score(query, reference)
      the_class.score(query, reference)
    end

    let(:null_match){score('query', 'reference')}

    it 'returns a number for the word score' do
      null_match.should be_a Fixnum
    end

    it 'gives a perfect score for a perfect match' do
      score('query', 'query').should == StringDistance::WordDistance::BINGO_SCORE
    end

    it 'can find a word inside another word' do
      score('LqueryR', 'query').should > null_match
    end

    it 'can find a word at the beginning of another' do
      score('queryR', 'query').should > null_match
    end

    it 'can find a word at the end of another' do
      score('Lquery', 'query').should > null_match
    end

    it 'should return the null value for any match thats negative' do
      word_score = score('buriedinthemessquerynesslessness', 'query')
      word_score.should == null_match
    end

    describe 'should rank any match higher than no match' do

      it 'eg. final match higher than null' do
        score('longquery', 'query').should >= null_match
      end

      it 'eg. word initial match higher than null' do
        score('querynesslessness', 'query').should >= null_match
      end

      it 'eg. a buried match higher than null' do
        word_score = score('buriedinthemessquerynesslessness', 'query')
        word_score.should >= null_match
      end
    end
  end
  describe 'parts of a score' do


    describe '#overlength penalty' do
      def overlength_penalty(query, reference)
        the_class.new(query, reference).overlength_penalty
      end

      it 'should take two strings as arguments' do
        overlength_penalty('query', 'reference')
      end

      it 'should be zero for same length words' do
        overlength_penalty('dogs', 'cats').should == 0
      end

      it 'should be positive if the query is longer than the reference' do
        overlength_penalty('alongerquery', 'reference').should > 0
      end

      it 'should be zero if the reference is longer than the query' do
        overlength_penalty('query', 'reference').should ==  0
      end

      it 'should be larger for larger differences' do
        ref   = 'ref'
        short = 'able'
        long  = 'ablebodied'
        short_penalty = overlength_penalty(short, ref)
        long_penalty  = overlength_penalty(long, ref)
        long_penalty.should > short_penalty
      end
    end

    describe '#offset penalty' do
      def offset_penalty(index)
        subject.offset_penalty(index)
      end

      it 'should be a float' do
        offset_penalty(1).should be_a Float
      end

      it 'should get larger the larger the integer is' do
        first =  offset_penalty(1)
        second = offset_penalty(2)
        first.should < second
      end
    end

    describe '#ancestor_score' do
      def ancestor_score(query, reference)
        the_class.new(query, reference).ancestor_score
      end

      it 'should return a float' do
        ancestor_score('affff', 'abced').should be_a Float
      end

      it 'should have a score of zero if there is no ancestor' do
        ancestor_score('a', 'b').should eq 0
        ancestor_score('a', 'bb').should eq 0
        ancestor_score('aa', 'b').should eq 0
      end

      it 'should have a greater score for fewer hops' do
        few  =  ancestor_score('catsa', 'cat')
        many =  ancestor_score('cats', 'cold')
        few.should > many
      end

      it 'only compare the length of the reference parts' do
        few  =  ancestor_score('randal',  'randy')
        many =  ancestor_score('randall', 'randy')
        few.should == many
      end

      it 'it should give a similar score ' do
        ancestor_score("peterson", 'pets').should eq 0.2
        ancestor_score("peterson", 'petre').should == 0.1
      end
    end

  end
end
