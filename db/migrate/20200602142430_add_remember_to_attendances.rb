class AddRememberToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :remember, :text
  end
end
