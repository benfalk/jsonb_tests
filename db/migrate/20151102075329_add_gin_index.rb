class AddGinIndex < ActiveRecord::Migration
  def change
    add_index :users, :details, using: :gin
  end
end
