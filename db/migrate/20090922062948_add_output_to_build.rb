class AddOutputToBuild < ActiveRecord::Migration
  def self.up
    add_column :builds, :output, :text
  end

  def self.down
  end
end
