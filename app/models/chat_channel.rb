class ChatChannel < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :chat_type
  has_and_belongs_to_many :users

  def self.find_or_create(user_1_id, user_2_id, chat_type_name = 'direct')
    ids = [user_1_id, user_2_id].sort

    @chat_channel = read_data_from_cache(direct_channel_name(ids))
    @chat_channel ||= find_and_write_cache(ids)

    return @chat_channel if @chat_channel.present?
    channel_type = ChatType.find_by(name: chat_type_name)
    create(name: direct_channel_name(ids), chat_type_id: channel_type.id, user_ids: ids, cache_user_ids: ids)
  end

  def self.read_data_from_cache(key)
    Rails.cache.read(key)
  end

  def self.write_data_to_cache(key, value)
    Rails.cache.write(key, value) && value
  end

  def self.find_and_write_cache(ids)
    value = where('cache_user_ids = ARRAY[:id_1, :id_2]', id_1: ids[0], id_2: ids[1]).take
    write_data_to_cache(direct_channel_name(ids), value) if value.present?
  end

  def self.direct_channel_name(ids)
    "direct_#{ids[0]}_#{ids[1]}"
  end
end
