class StaticController < ApplicationController

  layout false

  def index
    redirect_to partner_url(current_partner) if current_partner
  end

  def page
    # This allows for a flexible addition of static content
    # Anything under the url /pages/:name will render the file /app/views/static/[name].html.erb
    # Example: /pages/contact renders /app/views/static/contact.html.erb
    # Example2: /pages/index renders /app/views/static/index.html.erb, even when logged in
    render template: "static/#{params[:name]}"
  end
end
