module ApplicationHelper
  def humanize_boolean(boolean)
    I18n.t((!!boolean).to_s)
  end
end
