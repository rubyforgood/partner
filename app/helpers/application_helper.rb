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

  def partner_status_badge(partner)
    if @partner.partner_status == "Verified"
      content_tag :span, partner.partner_status, class: ["badge", "badge-pill", "badge-primary", "float-right"]
    elsif @partner.partner_status == "Recertification Required"
      content_tag :span, partner.partner_status, class: ["badge", "badge-pill", "badge-danger", "float-right"]
    end
  end
end
