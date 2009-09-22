class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.references :project
      t.string :sha
    end
  end

  def self.down
    drop_table :commits
  end
end
