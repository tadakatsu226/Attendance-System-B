class AddDayAfterToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :day_after, :boolean, default: false
  end
end
