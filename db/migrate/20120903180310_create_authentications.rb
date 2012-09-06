class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user
      t.string :provider
      t.string :uid
      t.text :information
      t.text :token

      t.timestamps
    end
    add_index :authentications, :user_id
  end
end
