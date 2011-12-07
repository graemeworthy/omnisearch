module OmniSearch::Engines

  class Regex < Base

    # def score_list
    #   @list.select!{|item| item[:value].downcase[0] == @term.downcase[0]}
    #   @list.each{|item|
    #     item[:score] = score(item)
    #   }
    # end

    def score(item)

      list_item = item[:value].downcase
      search_string = @term.downcase
      @matcher ||= /#{search_string}/
      list_item.match(@matcher).to_a.length
    end
  end

end