class AddNickToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :nick, :string
  end

  def self.down
    remove_column :people, :nick
  end
end
