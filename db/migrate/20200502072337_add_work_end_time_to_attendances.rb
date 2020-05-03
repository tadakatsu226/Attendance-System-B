class AddWorkEndTimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :work_end_time, :datetime
  end
end
