class CreateImpactStories < ActiveRecord::Migration[6.0]
  def change
    create_table :impact_stories do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.references :partner, index: true, foreign_key: true

      t.timestamps
    end
  end
end
