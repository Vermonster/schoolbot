class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.text :name, null: false
      t.text :slug, null: false
      t.text :contact_phone, null: false
      t.text :contact_email, null: false
      t.text :api_secret, null: false
      t.text :zonar_customer, null: false
      t.text :zonar_username, null: false
      t.text :zonar_password, null: false

      t.timestamps null: false

      t.index :slug, unique: true
      t.index :api_secret, unique: true
    end
  end
end
