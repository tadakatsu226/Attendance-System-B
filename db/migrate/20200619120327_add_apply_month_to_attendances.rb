class AddApplyMonthToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :apply_month, :string
  end
end
