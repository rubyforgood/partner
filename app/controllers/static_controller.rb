class StaticController < ApplicationController
  layout false

  def index
    redirect_to partner_path(current_partner) if current_partner
  end

  def page
    # This allows for a flexible addition of static content
    # Anything under the url /pages/:name will render the file /app/views/static/[name].html.erb
    # Example: /pages/contact renders /app/views/static/contact.html.erb
    # Example2: /pages/index renders /app/views/static/index.html.erb, even when logged in
    template = "static/#{params[:name]}"
    if %r{[^\w\-\/]+$}.match?(template)
      render file: "#{Rails.root}/public/400.html", status: :bad_request
    elsif lookup_context.exists?(template)
      render template: template
    else
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
