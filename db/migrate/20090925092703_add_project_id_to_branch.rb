class AddProjectIdToBranch < ActiveRecord::Migration
  def self.up
    add_column :branches, :project_id, :integer
    add_index :branches, :project_id
  end

  def self.down
    remove_column :branches, :project_id
  end
end
