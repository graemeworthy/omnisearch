module OmniSearch::Engines

  class Regex < Base
    def score(item)
      list_item = item[:value].downcase
      search_string = @term.downcase
      @matcher ||= /\b#{search_string}/
      list_item.match(@matcher).to_a.length
    end
  end

end
