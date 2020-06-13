class AddMonthReqAuthorizerToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_req_authorizer, :string
  end
end
