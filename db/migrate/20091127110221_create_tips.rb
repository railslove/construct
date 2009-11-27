class CreateTips < ActiveRecord::Migration
  def self.up
    create_table "tips", :force => true do |t|
      t.string  "command"
      t.string  "description"
      t.text    "text"
      t.integer "user_id"
    end
  end

  def self.down
    drop_table :tips
  end
end
