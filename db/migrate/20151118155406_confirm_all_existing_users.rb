class ConfirmAllExistingUsers < ActiveRecord::Migration
  def up
    User.where(confirmed_at: nil).update_all('confirmed_at = created_at')
  end

  def down
    User.where('confirmed_at = created_at').update_all(confirmed_at: nil)
  end
end
