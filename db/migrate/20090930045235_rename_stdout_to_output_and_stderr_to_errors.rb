class RenameStdoutToOutputAndStderrToErrors < ActiveRecord::Migration
  def self.up
    rename_column :builds, :stdout, :run_output
    rename_column :builds, :stderr, :run_errors
  end

  def self.down
  end
end
