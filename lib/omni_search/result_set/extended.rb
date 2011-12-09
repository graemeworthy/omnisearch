module OmniSearch

# Extended Results
 # ------------------------------------
 # extended results are a set of extra, linked records that are shown as a
 # special reward for having only one result!
 # these are specified in the model, and may be subject to caching
 # you know, for extra 'speed'

class ResultSet::Extended

   def self.find(results)
     instance = self.new(results)
     instance.extended_results
   end

   def initialize(result_sets)
     @result_sets = result_sets
   end

   def winner
      @result_sets.collect{|set| set.results}.flatten.first if winner?
   end

   def winner?
     @result_sets.collect{|set| set.results}.flatten.length == 1
   end

   def winner_index
     @result_sets.first.klass
   end

   def default_result
     []
   end

   def extended_results
     return default_result unless winner?

     begin
      index = winner_index.new
      index.extended_results_for(winner)

     rescue NotImplementedError
       default_result

     end
   end

end
end
