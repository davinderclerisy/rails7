class AddIsPublicAndIsDraftToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :is_public, :boolean, default: false
    add_column :posts, :is_draft, :boolean, default: false
  end
end
