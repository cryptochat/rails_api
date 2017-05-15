class PushNotification
  attr_accessor :provider, :user

  def initialize(provider, from_user_id, to_user_id)
    @provider = provider
    @from_user_id = from_user_id
    @to_user_id = to_user_id
  end

  def notify_new_message
    @provider.notify_new_message(self)
  end
end
