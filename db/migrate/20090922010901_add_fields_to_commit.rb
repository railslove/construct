class AddFieldsToCommit < ActiveRecord::Migration
  def self.up
    add_column :commits, :modified, :text
    add_column :commits, :added, :text
    add_column :commits, :removed, :text
    add_column :commits, :timestamp, :datetime
    add_column :commits, :author_id, :integer
    add_column :commits, :url, :string
    add_column :commits, :message, :text
  end
  
  def self.down
  end
end
