module OmniSearch

  class AutoCorrect

    # Usage
    # ========================
    # AutoCorrect.for('Sweets') => Correction.new('Sweets', 'Sugar')
    # AutoCorrect.for('Honey')  => 'Correction.new('Honey', Sugar')
    #
    # every 'mistake' should have one and only one 'correction'
    # no correction may also be a mistake
    #
    # Only one correction for a given mistake
    # AutoCorrect.add('mistake', 'correction')
    # AutoCorrect.add('mistake', 'alt correction') #=> raises AlreadyExists
    #
    # Many mistakes for any correction
    # AutoCorrect.add('bad', 'good')
    # AutoCorrect.add('soo bad', 'good')
    #
    # No corrections that are also mistakes!
    # AutoCorrect.add('treat',  'cookie')
    # AutoCorrect.add('cookie', 'scone') #=> raises CircularReference
    #
    # If you want to change something,
    attr_accessor :autocorrect_list

    STORAGE_ENGINE = OmniSearch::Indexes::Storage::AutoCorrect
    #pile of errors
    AutoCorrectError      = Class.new(StandardError)
    AlreadyExists     = Class.new(AutoCorrectError)
    CircularReference = Class.new(AutoCorrectError)

    ## Exposed Class Methods
    def self.for(mistake)
      self.new(mistake).for
    end

    def self.add(mistake, correction)
      self.new(mistake, correction).add
    end

    def self.remove(mistake)
      self.new(mistake).remove
    end

    def self.correcting_to(correction)
      self.new(nil, correction).correcting_to
    end

    def self.list
      self.new.list
    end


    def initialize(mistake = nil, correction = nil)
      @mistake = mistake
      @correction = correction
    end

    def for
      @correction = list[@mistake]
      if @correction
        return Correction.new(@mistake, @correction)
      else
        nil
      end
    end

    def add
      validate
      list[@mistake] = @correction
      save
    end

    def remove
      list.delete(@mistake)
    end

    def correcting_to
      list.select{ |k,v| v == @correction }.keys
    end

    def list
      @@list ||= {}
    end

    def load
      @@list = file.load
    end

    def save
      file.save(list)
    end


    def file
      self.class::STORAGE_ENGINE.new()
    end

    protected

    def validate
      existing?
      circular?
    end

    def existing?
      if list[@mistake] && list[@mistake] != @correction
        raise AlreadyExists,
          "#{@mistake} already exists in this index, " +
          "it is currently corrected to #{send(:for)}"
      end
    end

    def circular?
      if list.keys.include?(@correction)
        raise CircularReference
      end
    end


  end
end
