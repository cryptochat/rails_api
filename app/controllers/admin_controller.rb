class AdminController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_admin!
  before_action :reset_password

  layout 'admin'

  private

  def reset_password
    unless current_admin.is_password_changed
      render template: 'admin/admins/edit'
    end
  end
end
