require 'set'
class Trigram
  attr_reader :trigrams

  # generate trigram inverted index
  def self.build_index(list = [])
    this_index = Hash.new()
    list.each_with_index do |item, i|
      item ||= ''
      trigrams = self.to_trigrams(item)
      trigrams.each do |trigram|
        this_index[trigram] ||= []
        this_index[trigram] << i
      end
    end
    this_index
  end

  # Search the generated index
  # @param term is the search term
  # @param result_num is the number of matching results you want
  def self.search(index, term)
    this_index = index
    search_grams = to_trigrams(term)

    # grab all search index ids where the grams exist
    matched = []
    search_grams.each { |gram| matched << this_index[gram] }
    matched.flatten!
    matched.compact!

    # rank and sort matching ids
    match_counts = Hash.new(0) #zomg, hash can have a default value!
    matched.each{|match| match_counts[match] += 1}

    ranked_results = match_counts.sort { |y, x| x[1]<=>y[1] }
  end

  # you could make bigrams by changing 3 => 2 here
  def self.to_trigrams(str)
    self.clean_up(str)

    trigrams = Set.new
    str.split.each do |word|
      (0..word.length - 3).each do |idx|
        trigrams.add(word[idx, 3])
      end
    end

    trigrams
  end

  def self.clean_up(str)
    str.gsub!(/(\s|\(|\)|\-|\.|\/|\'|\,)+/, "")
    str.downcase!
  end

end
