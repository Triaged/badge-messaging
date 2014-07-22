class User
  include Mongoid::Document

  field :_id, type: String, default: -> { user_id }
  field :user_id, type: String

  has_and_belongs_to_many :message_threads
end
