class PopulateFamilyChildrenCount < ActiveRecord::Migration[5.2]
  def up
    Family.find_each do |family|
      Family.reset_counters(family.id, :children)
    end
  end
end
