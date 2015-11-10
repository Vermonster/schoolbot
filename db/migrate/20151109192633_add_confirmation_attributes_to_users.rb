class AddConfirmationAttributesToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :confirmation_token
      t.index :confirmation_token, unique: true
      t.datetime :confirmed_at
      t.text :unconfirmed_email
    end
  end
end
