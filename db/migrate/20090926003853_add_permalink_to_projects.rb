class AddPermalinkToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :permalink, :string
    add_index :projects, :permalink
  end

  def self.down
  end
end
