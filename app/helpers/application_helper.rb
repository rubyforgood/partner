module ApplicationHelper
  def humanize_boolean(boolean)
    I18n.t((!!boolean).to_s)
  end

  def active_class(name)
    name.include?(controller_name) ? "active" : controller_name
  end

  def valid_items_for_select(items)
    items.map { |item| [item["name"], item["id"]] }.sort
  end
end
