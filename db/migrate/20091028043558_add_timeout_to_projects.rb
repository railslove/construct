class AddTimeoutToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :timeout, :integer, :default => 600
  end

  def self.down
    remove_column :projects, :timeout
  end
end
