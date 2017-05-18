class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :description, :location, :icon, :online, :friends, :created_at, :updated_at
end
