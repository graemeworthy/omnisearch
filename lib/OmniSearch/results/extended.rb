module OmniSearch
class Results
 
# Extended Results
 # ------------------------------------
 # extended results are a set of extra, linked records that are shown as a
 # special reward for having only one result!
 # these are specified in the model, and may be subject to caching
 # you know, for extra 'speed'
 class Extended
   def self.find(results)     
     instance = self.new(results)
     instance.extended_results
   end
   def initialize(results)
     @results = results
   end
   def winner
     @results[winner_index].first
   end
   def winner?
     @results.collect{|k, v| v}.flatten.length == 1
   end
   def winner_index
     @results.select{|k, v|  v.length == 1}.keys.first
   end
   def default_result
     []
   end
   def extended_results
     return default_result unless winner?
     puts "results #{@results}"
     puts "winner_index #{winner_index}"
     begin
      index = winner_index.new
      index.extended_results_for(winner)
     rescue NotImplementedError 
       default_result
     end
   end
 end
end
end