class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true

  validates :email,
            presence: { message: "не может быть пустым" },
            uniqueness: { case_sensitive: false, message: "уже зарегистрирован" }

  validate :validate_password_complexity

  private

  def validate_password_complexity
    return if password.blank?

    errors.add(:password, "должен содержать минимум 8 символов") if password.length < 8

    unless password.match?(/[a-zA-Z]/) && password.match?(/[0-9]/)
      errors.add(:password, "должен содержать латинские буквы и цифры")
    end

    if password.match?(/[а-яА-ЯёЁ]/)
      errors.add(:password, "не может содержать русские буквы")
    end
  end
end