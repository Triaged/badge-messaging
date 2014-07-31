class HeartbeatService

	def self.received_heartbeat user_id
		#User.where(id: user_id).find_and_modify({ "$set" => { last_seen_at: Time.now.to_f}}, new: false)
		User.find(user_id).set_presence Time.now.to_f
	end
end