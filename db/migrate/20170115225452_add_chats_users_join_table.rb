class AddChatsUsersJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :chats_users do |t|
      t.references :chat, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
