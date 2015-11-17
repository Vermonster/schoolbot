class AddLocaleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :locale, :text, null: false, default: 'en'
  end
end
