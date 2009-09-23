class AddSiteToBuilds < ActiveRecord::Migration
  def self.up
    add_column :builds, :site, :string
  end

  def self.down
    remove_column :builds, :site
  end
end
