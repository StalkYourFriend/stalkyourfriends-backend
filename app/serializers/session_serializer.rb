class SessionSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :icon, :token
end