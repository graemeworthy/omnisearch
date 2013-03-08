require './spec/spec_helper'

describe 'unfinished specs' do
  before(:all) do
    Indexes.list.clear
    class Something
      def info
        "space"
      end
    end

    class SomethingIndex
      include Indexes::Register
      indexes :something
      def collection
        a_collection = []
        10.times{a_collection << Something.new}
        a_collection
      end
      def record_template(item)
        {:value => item.info}
      end
    end
    Indexes.build
  end

  after(:all) do
    Object.send(:remove_const, :Something)
    Object.send(:remove_const, :SomethingIndex)
    Indexes.list.clear
  end

  it 'should not fail while the following is happening' do
    Indexes.list #=> {"OmniSearch::Indexes"=>[SomethingIndex]}
    Indexes::Builder.new(SomethingIndex, Indexes::Plaintext).index_type
    Indexes::Builder.new(SomethingIndex, Indexes::Plaintext).index_class
    Indexes::Builder.new(SomethingIndex, Indexes::Plaintext).save


    Indexes::Builder.new(SomethingIndex, Indexes::Trigram).index_type
    Indexes::Builder.new(SomethingIndex, Indexes::Trigram).index_class
    Indexes::Builder.new(SomethingIndex, Indexes::Trigram).save

    Indexes::Fetcher.new(SomethingIndex, Indexes::Plaintext).records

    Indexes.build
    Indexes.list

    Indexes::Plaintext.build(SomethingIndex.new.all)
    Indexes::Trigram.build(SomethingIndex.new.all)

    ResultSet::Factory.new(Indexes::Plaintext, Engines::Regex, 'term', 0)



    Indexes::Builder.new(SomethingIndex, Indexes::Plaintext).save
    Indexes::Builder.new(SomethingIndex, Indexes::Trigram).save

    @records       = Indexes::Fetcher.new(
                        SomethingIndex,
                        Indexes::Trigram
                     ).records
    @string        = 'space'
    @results       = Trigram.search(@records, @string)
    @cutoff        = 0

    Engines::Triscore.score(@records, @string, @cutoff, SomethingIndex)
    ResultSet::Factory.sets(Indexes::Trigram, Engines::Triscore, 'spa', 0)


    fact =  ResultSet::Factory.new(
                  Indexes::Trigram,
                  Engines::Triscore,
                  'spa',
                  0)

    fact.result_sets


    ResultSet.new(Something, [])
    Result.new
  end
end

