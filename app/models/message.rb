class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  embedded_in :message_thread

  field :author_id, type: String
  field :body, type: String
  field :timestamp, type: Float
  field :read_by, type: Array

  
  
end
