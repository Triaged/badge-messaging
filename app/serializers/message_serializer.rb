class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :timestamp, :guid
end
