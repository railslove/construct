class ChangeStdoutToBlob < ActiveRecord::Migration
  def self.up
    change_column :builds, :stdout, :blob
    change_column :builds, :stderr, :blob
  end

  def self.down
  end
end
