# encoding: UTF-8
module OmniSearch::Engines

  # Deferring to tools/string_distance.rb
  #
  class StringDistance < Base
    def score(item)
      query = item[:value]
      reference = @term
      OmniSearch::StringDistance.score(query, reference)
    end
  end
end
