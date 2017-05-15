module Concerns
  module Users
    module Decorators
      extend ActiveSupport::Concern
      include ActionView::Helpers::UrlHelper

      delegate :url_helpers, to: 'Rails.application.routes'

      def edit_link
        link_to 'Редактировать', url_helpers.edit_admin_user_path(id), class: 'btn btn-warning btn-slim'
      end

      def status
        is_active ? "<p style='color: green;'>Активен</p>" : "<p style='color: red;'>Заблокирован</p>"
      end

      def notify_new_message(provider, from_user_id, to_user_id)
        provider = "PushNotificationStrategies::#{provider.capitalize}".constantize
        builder = PushNotification.new(provider.new, from_user_id, to_user_id)
        builder.notify_new_message
      end
    end
  end
end
