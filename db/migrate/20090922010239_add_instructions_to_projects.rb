class AddInstructionsToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :instructions, :text
  end

  def self.down
    remove_column :projects, :instructions
  end
end
