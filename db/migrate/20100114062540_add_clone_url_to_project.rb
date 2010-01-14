class AddCloneUrlToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :clone_url, :string
  end

  def self.down
    remove_column :projects, :clone_url
  end
end
