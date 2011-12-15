module OmniSearch
  class Search::Strategy

    def self.run(term)
      a = Time.now
      results = ResultSet::Factory.sets(Indexes::Plaintext, Engines::Regex, term, 0)
      b = Time.now
      puts "omnisearch regex: #{b-a}"
      if results == []
        a = Time.now
        results = ResultSet::Factory.sets(Indexes::Plaintext, Engines::StartDistance, term, 0.6)
        b = Time.now
        puts "omnisearch startdistance: #{b-a}"

      end
      if results == []
        a = Time.now
        results = ResultSet::Factory.sets(Indexes::Trigram, Engines::Triscore, term, 0.2)
        b = Time.now
        puts "omnisearch trigram: #{b-a}"
      end

      results
    end

  end
end  