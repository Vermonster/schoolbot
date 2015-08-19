class RemoveUnusedDeviseColumns < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        change_column_default :users, :email, nil
        change_column_default :users, :password_digest, nil
      end

      dir.down do
        change_column_default :users, :email, ''
        change_column_default :users, :password_digest, ''
      end
    end

    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer, default: 0, null: false
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :inet
    remove_column :users, :last_sign_in_ip, :inet
    remove_column :users, :failed_attempts, :integer, default: 0, null: false
    remove_column :users, :unlock_token, :text
    remove_column :users, :locked_at, :datetime
  end
end
