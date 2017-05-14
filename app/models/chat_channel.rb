class ChatChannel < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :users

  class << self
    def find_or_create(user_1_id, user_2_id)
      ids = [user_1_id.to_i, user_2_id.to_i].sort

      @chat_channel = read_data_from_cache(direct_channel_name(ids))
      @chat_channel ||= find_and_write_cache(ids)

      return @chat_channel if @chat_channel.present?
      create(name: direct_channel_name(ids), user_ids: ids, cache_user_ids: ids)
    end

    def read_data_from_cache(key)
      Rails.cache.read(key)
    end

    def write_data_to_cache(key, value)
      Rails.cache.write(key, value) && value
    end

    def find_and_write_cache(ids)
      value = where('cache_user_ids = ARRAY[:id_1, :id_2]', id_1: ids[0], id_2: ids[1]).take
      write_data_to_cache(direct_channel_name(ids), value) if value.present?
    end

    def direct_channel_name(ids)
      "direct_#{ids[0]}_#{ids[1]}"
    end
  end
end
