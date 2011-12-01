module OmniSearch
  # Results
  # -------------------------
  # Returned by Search as a collector of results
  #  contains a few important methods
  #  #searching_as
  #  #results
  #  #extended_results

  class Results

    def initialize(search_results_hash)
      @results = search_results_hash
      trim_to_max
    end
    # @searching_as
    # there can be only one official synonym for a search,
    # for example dortor => doctor, or docter => doctor
    attr_accessor :searching_as

    # @top
    # the highest scoring or otherwise determined super champ
    def top
      Top.find(@results)
    end

    # @results
    # I wish i had a better name for these,
    # it's a hash of results collected from the various indexed datasets
    def results
      @results
    end

    # @extended_results
    # in some cases we want to provide
    # an extra set of results to help the user with things we basically know
    # they are searching for, these will be in the same format as the 'results'
    # but live here, under a different heading because they're non-default
    def extended_results
      Extended.find(@results)
    end
    def inspect
      {:top_hit => top, :results => results, :extended => extended_results}
    end

    protected

    def trim_to_max
      input = @results
      output = {}
      input.each{|k, v|
        output[k] = v.take(5)
       }
      @results = output
    end

  end



end
