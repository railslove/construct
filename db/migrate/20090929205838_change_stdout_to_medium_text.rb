class ChangeStdoutToMediumText < ActiveRecord::Migration
  def self.up
    change_column :builds, :stdout, :mediumtext
    change_column :builds, :stderr, :mediumtext
  end

  def self.down
  end
end
