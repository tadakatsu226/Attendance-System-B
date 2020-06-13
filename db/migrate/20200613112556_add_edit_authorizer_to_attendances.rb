class AddEditAuthorizerToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_authorizer, :string
  end
end
