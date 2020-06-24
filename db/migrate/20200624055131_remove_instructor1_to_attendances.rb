class RemoveInstructor1ToAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :instructor1, :text
  end
end
