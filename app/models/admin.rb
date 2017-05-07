class Admin < ApplicationRecord
  include Concerns::Admins::Decorators

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :recoverable, :rememberable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable
end
