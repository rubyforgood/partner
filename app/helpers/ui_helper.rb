module UiHelper
  def filter_button(options = {})
    _button_to({ icon: "filter", type: "primary", text: "Filter", size: "md" }.merge(options))
  end

  def cancel_button_to(link, options = {})
    _link_to link, { icon: "ban", type: "outline-primary", text: "Cancel", size: "md" }.merge(options)
  end

  def _link_to(link, options = {}, properties = {})
    icon = options[:icon]
    text = options[:text]
    size = options[:size]
    type = options[:type]
    # user sparingly.
    center = options[:center].present? ? "center-block" : ""

    link_to link, properties.merge(class: "btn btn-#{type} btn-#{size} #{center}") do
      fa_icon icon, text: text
    end
  end

  def _button_to(options = {}, other_properties = {})
    submit_type = options[:submit_type] || "submit"
    id   = options[:id]
    type = options[:type]
    size = options[:size]
    icon = options[:icon]
    text = options[:text]
    align = options[:align]

    button_tag({ type: submit_type, id: id, class: "btn btn-#{type} btn-#{size} #{align}" }.merge(other_properties)) do
      fa_icon icon, text: text
    end
  end
end
