class AddBasicWorkTime1 < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basic_work_time1, :datetime
  end
end