json.array! @chats do |chat|
  json.set! :chat do
    json.id chat.id
    json.name chat.name
    json.user_ids chat.users.pluck(:id)
  end
end
