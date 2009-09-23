class AddSiteToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :site, :string 
  end

  def self.down
    remove_column :projects, :site
  end
end
