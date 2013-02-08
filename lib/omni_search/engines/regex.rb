# encoding: UTF-8
module OmniSearch::Engines
  # a simple scoring system
  class Regex < Base
    # binary match detector, returns a 1 or a a zero
    def score(item)
      list_item = item[:value].downcase
      search_string = @term.downcase
      safe_string = Regexp.escape(search_string)
      @matcher ||= /\b#{safe_string}/
      list_item.match(@matcher).to_a.length
    end

  end
end
