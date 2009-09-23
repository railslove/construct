class AddBuildDirectoryToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :build_directory, :string
  end

  def self.down
  end
end
