class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
      t.string :session_token, null: false
      t.index :session_token, unique: true
      
    end
  end
end
