module PushNotificationStrategies
  class Apple
    def initialize
      cert = Rails.env.production? ? 'apple_production' : 'apple_staging'
      @rpush     = Rpush::Apns::Notification.new
      @rpush.app = Rpush::Apns::App.find_by_name(cert)
    end

    def notify_new_message(context)
      device_tokens = DeviceToken.joins(:device_token_type)
                                 .where(user_id: context.to_user_id, device_token_types: { name: 'apple' })

      return nil unless device_tokens.present?
      device_tokens.each do |device_token|
        @rpush.device_token = device_token.value
        @rpush.alert = 'Вам прислали сообщение'
        @rpush.data = { interlocutor_id: context.from_user_id }
        @rpush.save!
      end
    end
  end
end
