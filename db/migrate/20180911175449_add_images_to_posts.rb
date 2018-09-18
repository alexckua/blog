# frozen_string_literal: true

class AddImagesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :images, :string
  end
end
