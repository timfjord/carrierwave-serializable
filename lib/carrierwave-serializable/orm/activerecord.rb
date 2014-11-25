# encoding: utf-8

require "carrierwave/orm/activerecord"

module CarrierWave
  module ActiveRecord
    module Serializable
      def serialized_uploaders
        @serialized_uploaders ||= if superclass.respond_to?(:serialized_uploaders)
                                    superclass.serialized_uploaders
                                  else
                                    {}
                                  end
      end

      def serialized_uploader?(column)
        attribute_name = serialized_uploaders[column].to_s
        serialized_uploaders.key?(column) && (serialized_attribute?(attribute_name) ||
                                              hstore_attribute?(attribute_name) ||
                                              json_attribute?(attribute_name))

      end

      def serialized_attribute?(attribute)
        serialized_attributes.key?(attribute)
      end

      def hstore_attribute?(attribute)
        columns_hash[attribute.to_s].type == :hstore
      end

      def json_attribute?(attribute)
        columns_hash[attribute.to_s].type == :json
      end

      ##
      # See +CarrierWave::Mount#mount_uploader+ for documentation
      #
      def mount_uploader(column, uploader=nil, options={}, &block)
        super

        serialize_to = options.delete :serialize_to
        if serialize_to
          serialization_column = options[:mount_on] || column
          serialized_uploaders[serialization_column] = serialize_to
          class_eval <<-RUBY, __FILE__, __LINE__+1
            def #{serialization_column}_will_change!
              #{serialize_to}_will_change!
              @#{serialization_column}_changed = true
            end

            def #{serialization_column}_changed?
              @#{serialization_column}_changed
            end
          RUBY
        end
        class_eval <<-RUBY, __FILE__, __LINE__+1
          def write_uploader(column, identifier)
            if self.class.serialized_uploader?(column)
              serialized_field = self.send self.class.serialized_uploaders[column]
              serialized_field[column.to_s] = identifier
            else
              write_attribute(column, identifier)
            end
          end

          def read_uploader(column)
            if self.class.serialized_uploader?(column)
              serialized_field = self.send self.class.serialized_uploaders[column]
              serialized_field ? serialized_field[column.to_s] : nil
            else
              read_attribute(column)
            end
          end
        RUBY

      end
    end # Serializable
  end # ActiveRecord
end # CarrierWave
