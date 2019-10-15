class AddChildrenCountToFamilies < ActiveRecord::Migration[5.2]
  def change
    add_column :families, :children_count, :integer, default: 0
  end
end
