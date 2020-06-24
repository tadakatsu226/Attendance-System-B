class RemoveInstructorToAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :instructor, :text
  end
end
