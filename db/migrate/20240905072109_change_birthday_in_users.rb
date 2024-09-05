class ChangeBirthdayInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :birthday, :date
  end
end
