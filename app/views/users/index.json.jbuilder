json.array! @users do |user|
  json.set! :user do
    json.id user.id
    json.name user.name
    json.messages_count user.messages_count
  end
end
