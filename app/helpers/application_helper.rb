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

  def valid_items_for_select_tag(items, picked_up_item_diaperid, item_ordered_diaperid)
    valid_item_objects = items.map do |item|
      OpenStruct.new(id: item["id"], name: item["name"])
    end
    options_from_collection_for_select(
      valid_item_objects,
      :id,
      :name,
      selected: picked_up_item_diaperid || item_ordered_diaperid
    )
  end

  def partner_status_badge(partner)
    if @partner.partner_status == "verified"
      tag.span partner.partner_status, class: %w(badge badge-pill badge-primary float-right)
    elsif @partner.partner_status == "recertification_required"
      tag.span partner.partner_status, class: %w(badge badge-pill badge-danger float-right)
    else
      tag.span partner.partner_status, class: %w(badge badge-pill badge-info float-right)
    end
  end

  def flash_class(level)
    case level
    when "notice" then "alert notice alert-info"
    when "success" then "alert success alert-success"
    when "error" then "alert error alert-danger"
    when "alert" then "alert alert-warning"
    end
  end

  # Change Devise's default redirect path after sign in
  def after_sign_in_path_for(resource)
    dashboard_path || super
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end
end
