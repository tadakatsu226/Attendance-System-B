class AddEditStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_status, :string
  end
end
