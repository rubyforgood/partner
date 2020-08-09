class UsersController < ApplicationController
  def index
    @users = current_partner.users
  end
end
