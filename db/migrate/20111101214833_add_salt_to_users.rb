class AddSaltToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :salt, :string
  end
  
  def self.down
    remove_columns :users, :salt
  end  
end
