module OmniSearch::Engines

class Regex < Plain::Base
  def cutoff
    1
  end

  def score(item)
    list_item = item.downcase
    search_string = @string.downcase
    @matcher ||= /#{search_string}/
    list_item.match(@matcher).to_a.length
  end
end

end