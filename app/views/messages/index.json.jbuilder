json.array! @messages do |message|
  json.set! :message do
    json.id message.id
    json.content message.content
  end
end
