class User
  include Mongoid::Document

  has_and_belongs_to_many :message_threads
end
