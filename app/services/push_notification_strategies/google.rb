module PushNotificationStrategies
  class Google
    def initialize
      cert = Rails.env.production? ? 'google_production' : 'google_staging'
      @rpush     = Rpush::Gcm::Notification.new
      @rpush.app = Rpush::Gcm::App.find_by_name(cert)
    end

    def notify_new_message(context)
      device_tokens = DeviceToken.joins(:device_token_type)
                                 .where(user_id: context.to_user_id, device_token_types: { name: 'google' })

      return nil unless device_tokens.present?
      @rpush.registration_ids = device_tokens.map(&:value)
      @rpush.data = { message: 'Вам прислали сообщение' }
      @rpush.notification = { interlocutor_id: context.from_user_id }
      @rpush.save!
    end
  end
end
