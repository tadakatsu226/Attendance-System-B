class RenameSuperiorToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :superior, :superior1
    
  end
end
