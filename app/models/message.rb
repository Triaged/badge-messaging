class Message
  include Mongoid::Document

  embedded_in :message_thread

  field :author_id, type: String
  field :body, type: String
  field :timestamp, type: DateTime
  


  def as_json
  	{
  		id: self.id.to_s,
  		author_id: self.author_id,
  		timestamp: self.timestamp,
  		body: self.body
		}
	end

  
end
