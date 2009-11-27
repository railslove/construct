class AddAuthorizedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :authorized, :boolean, :default => false
  end

  def self.down
    remove_column :people, :authorized
  end
end
