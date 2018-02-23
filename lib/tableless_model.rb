# frozen_string_literal: true

require 'tableless_model/version'

# Upon inclusion, provides basic static data model functionality:
#
# class A
#   include TablelessModel
#   self.data_store = [
#     { id: 1, name: 'A1' },
#     { id: 2, name: 'A2' }
#   ]
# end
#
# This will give you:
#
# A.all.first.id # => 1
# A.all.last.name # => 'A2'
module TablelessModel
  # Build a new instance of the model from the params Hash
  #
  # @param [Hash] hash The attributes to be set
  def initialize(hash = {})
    # hash.symbolize_keys!
    not_matching_keys = hash.keys - self.class.attribute_names
    if not_matching_keys.any?
      raise "#{self.class}::new does not accept keys #{not_matching_keys}."
    end

    hash.each do |name, value|
      instance_variable_set "@#{name}", value
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  # :nodoc:
  module ClassMethods
    # Returns all instances of the model as listed in the data_store
    def all
      @all ||= data_store.map do |attrs|
        new(attrs)
      end
    end

    # Returns a specific model instance according to the given id
    #
    # @param [String] id the identifier of the instance
    # @raise [ActiveRecord::RecordNotFound] if no attachment context type
    #        was found for the given id
    # @return [model class] the instance for the given id
    def find(id)
      all.find { |instance| instance.id == id } ||
        raise(ActiveRecord::RecordNotFound, "Couldn't find #{self} with #{id}")
    end

    attr_reader :attribute_names

    private

    attr_reader :data_store

    def data_store=(ary)
      @data_store = ary
      self.attribute_names = ary.map(&:keys).flatten.uniq
    end

    def attribute_names=(ary)
      @attribute_names = ary
      attr_reader(*@attribute_names)
    end
  end
end
