class AddUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.jsonb :details, null: false, default: '{}'
      t.timestamps null: false
    end
  end
end
