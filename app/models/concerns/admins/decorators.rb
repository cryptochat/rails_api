module Concerns
  module Admins
    module Decorators
      extend ActiveSupport::Concern
      include ActionView::Helpers::UrlHelper

      delegate :url_helpers, to: 'Rails.application.routes'

      def edit_link
        link_to 'Редактировать', url_helpers.edit_admin_admin_path(id), class: 'btn btn-warning btn-slim'
      end
    end
  end
end
