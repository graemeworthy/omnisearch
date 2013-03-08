# encoding: UTF-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8 # <- THIS
Encoding.default_internal = nil # <- THIS

module OmniSearch

  module Indexes::Storage

    #
    # Storage::Base
    # =================
    # for saving and retrieving records to a file specified by the argment
    # nothing that important really, just that
    #
    # I've made three Flavours
    #  Storage::Plaintext
    #  Storage::Trigram
    #  Storage::AutoCorrect
    #
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
    class Base
      attr_accessor :records
      attr_reader   :index_name

      BASE_FILENAME = 'omnisearch_index'

      def initialize(name = nil)
        @index_name = name
      end

      # public
      # saves records to disk.
      def save(records)
        mkdir
        File.open(file_path, 'w') { |f| f.puts serialize(records) }
      end

      # public
      # loads from storage or raises MissingIndexFile
      #
      def load
        unless exists?
          raise MissingIndexFile, "could not file the file #{file_path}"
        end
        file   = File.read(file_path)
        loaded = deserialize(file)
        return loaded
      end

      # public
      # destroys the records used by this storage
      def delete
        `rm #{file_path}`
      end

      # public
      # creates an empty record
      def touch
        mkdir
        `touch #{file_path}`
      end

      # public
      # the location of the storage file
      def file_path
        File.join(root_path, filename)
      end

      protected

      def serialize(records)
        YAML::dump(records)
      end

      def deserialize(serialized_data)
        YAML::load(serialized_data)
      end

      def exists?
        File.exists?(file_path)
      end

      def filename
        if @index_name
          self.class::BASE_FILENAME + '_' + @index_name
        else
          self.class::BASE_FILENAME
        end
      end

      def mkdir
        unless File.exists?(root_path) && File.directory?(root_path)
          #puts "creating directories"
          `mkdir -p -v #{root_path}`
        end
      end

      def root_path
        OmniSearch.configuration.path_to_index_files.to_s
      end

    end

    # FIXME, while plain these things should be in thier own files
    # same as the base index, but with a different save location
    class Plaintext < Base
      BASE_FILENAME = 'omnisearch_plaintext_index'
    end

    # same as the base index, but with a different save location
    class Trigram < Base
      BASE_FILENAME = 'omnisearch_trigram_index'
    end

    # same as the base index, but with a different save location
    class AutoCorrect < Base
      BASE_FILENAME = 'omnisearch_autocorrect_index'
    end

  end
end
