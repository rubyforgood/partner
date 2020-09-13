class ImpactStory < ApplicationRecord
  belongs_to :partner

  def blurb(limit)
    if content.length > limit then "#{content[0, limit]}…" else content end
  end
end
