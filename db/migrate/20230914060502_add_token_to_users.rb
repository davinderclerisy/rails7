class AddTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :token, :text
  end
end
