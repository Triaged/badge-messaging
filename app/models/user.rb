class User
  include Mongoid::Document

  field :_id, type: String, default: -> { user_id }
  field :user_id, type: String
  field :subscriptions, type: Integer
  field :authentication_token, type: String
  field :last_seen_at, type: Float

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

  def present?
    time_diff = Time.now.to_f - self.last_seen_at
    Emlogger.instance.log time_diff
    self.last_seen_at && (time_diff > 0) && (time_diff < 0.250)
  end

  def pending_message_threads 
    self.message_threads.where(:u_at.gte => self.last_seen_at)
  end

  def pending_message_threads_since timestamp
    self.message_threads.where(:u_at.gte => timestamp.to_f)
  end

  def self.fetch_and_create_remote user_id
    Emlogger.instance.log "fetch or create"
    remote_user = BadgeClient.new.user(user_id)
    Emlogger.instance.log remote_user.inspect
    User.create(user_id: remote_user)
  end

  def self.find_or_fetch user_id
    User.find(user_id) || fetch_and_create_remote(user_id)
  end

end
