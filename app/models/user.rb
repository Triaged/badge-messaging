class User
  include Mongoid::Document

  field :_id, type: String, default: -> { user_id }
  field :user_id, type: String
  field :subscriptions, type: Integer
  field :authentication_token, type: String
  field :last_seen_at, type: DateTime

  has_and_belongs_to_many :message_threads, autosave: true

  def valid_auth_token? auth_token
		if self.authentication_token && (self.authentication_token == auth_token)
  		return true
  	else
  		valid = check_auth_token_with_remote auth_token
  		valid ? self.update_attribute(:authentication_token, auth_token) : self.update_attribute(:authentication_token, nil) 
  		return valid
  	end
	end

  

  def check_auth_token_with_remote auth_token
  	BadgeClient.new.valid_auth_token_for_user(self.id, auth_token)
  end

  def subscribed
    self.inc(subscriptions: 1)
  end

  def unsubscribed
    self.inc(subscriptions: -1) if (self.subscriptions > 0)
    self.update_attribute(:last_seen_at, DateTime.now)
  end

  def pending_message_threads
    self.messages_threads.where(:c_at.gte => self.last_seen_at)
  end

  def self.fetch_and_create_remote user_id
    remote_user = BadgeClient.new.user(user_id)
    User.create(user_id: remote_user)
  end

  def self.find_or_fetch user_id
    User.find(user_id) || fetch_and_create_remote(user_id)
  end

end
