class AddCustomer < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.json :details, null: false, default: '{}'
      t.timestamps null: false
    end
  end
end
