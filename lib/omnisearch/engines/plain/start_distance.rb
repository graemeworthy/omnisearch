module OmniSearch::Engines

class StartDistance < Plain::Base
  def cutoff
    0.1
  end

  def score(item)
    list_item = item.downcase
    search_string = @string.downcase

    dist = list_item.index(search_string)

    if dist == nil
      return 0
    else
      dist += 1
    end
    1.0/dist
  end
end

end