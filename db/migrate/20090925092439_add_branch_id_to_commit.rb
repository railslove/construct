class AddBranchIdToCommit < ActiveRecord::Migration
  def self.up
    add_column :commits, :branch_id, :integer
    add_index :commits, :branch_id
  end

  def self.down
    remove_column :commits, :branch_id
  end
end
