require "carrierwave"
require "carrierwave-serializable/version"
require "carrierwave-serializable/orm/activerecord"

ActiveRecord::Base.extend CarrierWave::ActiveRecord::Serializable if defined?(ActiveRecord)
