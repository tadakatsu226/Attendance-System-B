class AddBegintimeAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :begintime_at, :datetime
  end
end
