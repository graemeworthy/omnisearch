module OmniSearch
  # Results
  # -------------------------
  # Returned by Search as a collector of results 
  #  contains a few important methods
  #  #searching_as
  #  #results
  #  #extended_results

  class Results
    # @searching_as
    # there can be only one official synonym for a search,
    # for example dortor => doctor, or docter => doctor
    attr_accessor :searching_as

    # @results
    # I wish i had a better name for these,
    # it's a hash of results collected from the various indexed datasets
    attr_accessor :results

    # @extended_results
    # in some cases we want to provide
    # an extra set of results to help the user with things we basically know
    # they are searching for, these will be in the same format as the 'results'
    # but live here, under a different heading because they're non-default
    attr_accessor :extended_results

  end
end
