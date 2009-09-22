class CreateBuilds < ActiveRecord::Migration
  def self.up
    create_table :builds do |t|
      t.text :payload
      t.string :status
      t.references :commit
      t.timestamps
    end
  end

  def self.down
    drop_table :builds
  end
end
