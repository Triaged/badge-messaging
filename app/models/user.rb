class User
  include Mongoid::Document

  field :user_id, type: String

  has_and_belongs_to_many :message_threads
end
