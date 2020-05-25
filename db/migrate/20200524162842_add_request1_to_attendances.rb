class AddRequest1ToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :request1, :text
  end
end
