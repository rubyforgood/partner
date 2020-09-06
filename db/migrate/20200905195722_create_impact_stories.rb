class CreateImpactStories < ActiveRecord::Migration[6.0]
  def change
    create_table :impact_stories do |t|
      t.string :title
      t.text :content
      t.integer :partner_id

      t.timestamps
    end
  end
end
