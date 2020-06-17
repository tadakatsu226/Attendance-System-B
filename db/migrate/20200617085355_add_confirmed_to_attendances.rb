class AddConfirmedToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :confirmed, :string
  end
end
