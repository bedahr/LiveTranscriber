class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :email

  validates_uniqueness_of :name

  validates_confirmation_of :password
  validates_presence_of     :password, :on => :create

  has_secure_password

  include Extendable

  has_many :recordings
end
