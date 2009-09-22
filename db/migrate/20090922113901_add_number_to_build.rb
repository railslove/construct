class AddNumberToBuild < ActiveRecord::Migration
  def self.up
    add_column :builds, :number, :integer
  end

  def self.down
    remove_column :builds, :number
  end
end
