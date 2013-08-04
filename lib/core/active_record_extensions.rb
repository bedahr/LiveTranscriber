require 'active_record_chain'

module ActiveRecordExtensions
  extend ActiveSupport::Concern

  def name_with_id
    "#{id}: #{name || 'N/A'}" if respond_to?(:name)
  end

  def class_with_id
    "#{self.class}: #{id}"
  end

  module ClassMethods

    def chain
      ActiveRecordChain.new(self)
    end

  end
end
