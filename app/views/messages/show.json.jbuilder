json.set! :message do
  json.id @message.id
  json.content @message.content
  json.chat_id @message.chat_id
end
