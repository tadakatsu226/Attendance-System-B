class AddMonthReqStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_req_status, :string
  end
end
