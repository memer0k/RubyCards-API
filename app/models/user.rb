class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :name, presence: true

  # Генерируем токен при создании пользователя
  before_create :generate_auth_token

  private

  def generate_auth_token
    self.auth_token = SecureRandom.hex(20)
  end
end