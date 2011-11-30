module OmniSearch::Engines

class StringScore < Plaintext::Base
  def cutoff
    0.3
  end

  def score(item_value)
    item_value = item_value.downcase
    item_value = item_value.strip
    item_value.score(@string, 0.5)
  end
end

end
