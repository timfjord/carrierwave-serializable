# encoding: utf-8

require "carrierwave/orm/activerecord"

module CarrierWave
  module ActiveRecord
    module Serializable
      def serialized_uploaders
        @serialized_uploaders ||= {}
      end
    
      def serialized_uploader?(column)
        serialized_uploaders.key?(column) && serialized_attributes.key?(serialized_uploaders[column].to_s)
      end
      
      ##
      # See +CarrierWave::Mount#mount_uploader+ for documentation
      #
      def mount_uploader(column, uploader=nil, options={}, &block)
        super
        
        serialize_to = options.delete :serialize_to
        if serialize_to
          serialized_uploaders[column] = serialize_to 
          class_eval <<-RUBY, __FILE__, __LINE__+1
            def #{column}_will_change!
              #{serialize_to}_will_change!
              @#{column}_changed = true
            end

            def #{column}_changed?
              @#{column}_changed
            end
          RUBY
        
        
        class_eval <<-RUBY, __FILE__, __LINE__+1
          def write_uploader(column, identifier)
            if self.class.serialized_uploader?(column)
              serialized_field = self.send self.class.serialized_uploaders[column]
              serialized_field[column.to_s] = identifier
            else
              super
            end
          end

          def read_uploader(column)
            if self.class.serialized_uploader?(column)
              serialized_field = self.send self.class.serialized_uploaders[column]
              serialized_field[column.to_s]
            else
              super
            end
          end
        RUBY

        end
      end
    end # Serializable
  end # ActiveRecord
end # CarrierWave