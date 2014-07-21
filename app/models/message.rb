class Message
  include Mongoid::Document

  embedded_in :message_thread

  field :author_id, type: String
  field :body, type: String
  field :timestamp, type: DateTime
  field :guid, type: String
  
end
