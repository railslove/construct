class AddInstructionsToBuild < ActiveRecord::Migration
  def self.up
    add_column :builds, :instructions, :text
  end

  def self.down
  end
end
