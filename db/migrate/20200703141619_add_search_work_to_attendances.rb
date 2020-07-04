class AddSearchWorkToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :search_work, :date
  end
end
