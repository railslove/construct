class AddNameToBranches < ActiveRecord::Migration
  def self.up
    add_column :branches, :name, :string
    add_index :branches, [:project_id, :name]
  end

  def self.down
  end
end
