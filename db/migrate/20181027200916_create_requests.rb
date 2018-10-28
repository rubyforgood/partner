class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :partner_requests do |t|
      t.text :comments
      t.references :partner
      t.references :organization
      t.boolean :sent
      t.timestamps
    end
  end
end
