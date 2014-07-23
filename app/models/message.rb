class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  embedded_in :message_thread

  field :author_id, type: String
  field :body, type: String
  field :timestamp, type: DateTime
  field :read_by, type: Array

  def timestamp=(timestamp)
  	super(timestamp.to_f)
	end
  
end
