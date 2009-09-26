class RenameOutputToStdoutAddStderr < ActiveRecord::Migration
  def self.up
    rename_column :builds, :output, :stdout
    add_column :builds, :stderr, :text
  end

  def self.down
  end
end
