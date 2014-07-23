class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  embedded_in :message_thread

  field :author_id, type: String
  field :body, type: String
  field :timestamp, type: DateTime
  field :read_by, type: Array

  def attributes
  	{
  		_id: self.id.to_s,
  		author_id: self.author_id,
  		body: self.body,
  		timestamp: self.timestamp.to_f
  	}
  end
  
end
