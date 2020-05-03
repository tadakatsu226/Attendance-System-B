class AddSuperior2ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :superior2, :boolean, default: false
  end
end
