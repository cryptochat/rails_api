class ChatAttachmentType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
