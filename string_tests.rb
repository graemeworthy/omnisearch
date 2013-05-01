#
# Need specific searches to return what you want and not others?
# write some tests!
# here is a little dsl of how to test for presence and absence of results

require 'pp'
full_search = lambda {
    @found = []
    @found_a = []
    OmniSearch::Search::Strategy.run(@term).each do |set|
      set.results.each do |result|
        @found << result.value.downcase
        @found_a << "#{result.value.downcase} #{result.score}"
      end
    end
}

test_search = lambda {
  @found   =  []
  @found_a =  []

  OmniSearch::Engines::StringDistance.score(@search_index, @term, @cutoff).each {|result|
    @found   << result.value.downcase
    @found_a << "#{result.value.downcase} #{result.score}"
  }

}
@search = test_search

runner = lambda do
  @missing = {}
  @overage = {}

  def given(*args)
    @search_index = []
    args.each do |item|
      @search_index << {value: item, label: item}
    end
  end

  def my_search(term)
    @term = term
    @search.call
    @found
  end

  def has(result)
    unless @found.include?(result) == true
      p "missing #{result}"
      @missing[@term] ||= []
      @missing[@term] << result
    end
  end

  def has_no(result)
    where = @found.index(result)
    if where
      p "shouldn't have #{result}"

      @overage[@term] ||= []
      @overage[@term] << @found_a[where]
    end
  end

  @search = test_search
  given 'primary care', 'mary rose'
  my_search 'mary'
  has 'mary rose'
  has_no 'primary care'

  given 'mary rose'
  my_search 'mari rose'
  has 'mary rose'

  given 'Robert Marsan', 'Marianne Rochester', 'marianne rose'
  my_search 'mary'
  has_no 'robert marsan'

  given 'primary care', 'cancer care', 'Preschooler test or procedure preparation', 'palliative care'
  my_search 'primary care'
  has_no 'cancer care'
  has_no 'Preschooler test or procedure preparation'
  has_no 'palliative care'

  given 'robert marsan', 'marianne rochester', 'marianne rose', "blood and marrow transplantation", "del mar"
  my_search 'mary rose'
  has_no 'del_mar'
  has_no 'blood and marrow transplantation'

  given 'recognizing medical emergencies', "medical records"
  my_search 'medical records'
  has 'medical records'
  has_no 'recognizing medical emergencies'

  if OmniSearch::Indexes.list != []
    @search = full_search
    my_search 'mari rose'
    has 'mary rose'
  end

  puts "Missing: "
  pp @missing
  puts "Overage: "
  pp @overage

end
@cutoff = 0.55
runner.call
