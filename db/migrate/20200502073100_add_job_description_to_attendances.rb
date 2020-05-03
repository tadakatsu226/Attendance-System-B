class AddJobDescriptionToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :job_description, :text
  end
end
