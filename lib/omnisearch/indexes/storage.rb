module OmniSearch
class Indexes
  ##
  ##
  #
  # IndexFile
  # =================
  # for saving and retrieving records to a file specified by the argment
  # nothing that important really, just that
  # I've made two Flavours
  #  Storage::Plain
  #  Storage::Trigram
  #
  # Usage:
  # ------------------
  # persistence = IndexFile::Base.new('subname')
  #  saves and loads to 'omnisearch_index_subname'
  #
  # #save -- dumps it full of yaml-ized content
  #   some_hash = {}
  #   persistence.save(some_hash)
  #
  # #load -- loads back that same content
  #   reloaded_hash = persistence.load
  #   reloaded_hash == some_hash
  #
  ##
  ##


module Storage

  class Base
    attr_accessor :records
    attr_reader   :index_name

    BASE_FILENAME = 'omnisearch_index'
    PATH = '/tmp/omnisearch/'

    def initialize(name)
      @index_name = name
    end

    def save(records)
      mkdir
      File.open(file_path, 'w') do |f|
          YAML.dump(records, f)
      end
    end

    def load
      YAML::load_file(file_path)
    end

    protected

    def filename
      (self.class::BASE_FILENAME) + "_" + @index_name
    end

    def file_path
       File.join(self.class::PATH, filename)
    end

    def mkdir
      unless File.exists?(self.class::PATH) and File.directory?(self.class::PATH)
       Dir.mkdir(self.class::PATH)
      end
    end

  end

  # same as the base index, but with a different save location
  class Plain < Base
    BASE_FILENAME = 'omnisearch_plain_index'
  end

  # Same as base index, but with a different save location
  class Trigram < Base
    BASE_FILENAME = 'omnisearch_trigram_index'
  end

end
end
end
