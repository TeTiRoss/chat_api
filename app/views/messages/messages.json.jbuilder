json.array! @messages do |message|
  json.set! :message do
    json.id message.id
    json.content message.content
    json.chat_id message.chat_id
    json.user_id message.user_id
  end
end
