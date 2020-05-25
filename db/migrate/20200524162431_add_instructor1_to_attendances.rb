class AddInstructor1ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor1, :text
  end
end
