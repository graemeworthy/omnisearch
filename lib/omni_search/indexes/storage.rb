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

      def touch
        mkdir
        `touch #{file_path}`
      end

      def save(records)
        mkdir
        File.open(file_path, 'w') do |f|
          yaml_output = records.to_yaml
          f.puts yaml_output
        end
      end

      def load
        unless exists?
          raise MissingIndexFile, "could not file the file #(file_path)"
        end
        file   = File.read(file_path)
        loaded = YAML::load(file);
        return loaded
      end

      def exists?
        File.exists?(file_path)
      end

      def filename
        if @index_name
          self.class::BASE_FILENAME + "_" + @index_name
        else
          self.class::BASE_FILENAME
        end
      end

      def file_path
        File.join(root_path, filename)
      end

      protected

      def mkdir
        unless File.exists?(root_path) and File.directory?(root_path)
          #puts "creating directories"
          `mkdir -p -v #{root_path}`
        end
      end

      def root_path
        OmniSearch.configuration.path_to_index_files.to_s
      end

    end

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
