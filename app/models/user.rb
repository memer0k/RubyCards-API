class User < ApplicationRecord
  has_secure_password

  # Валидация имени
  validates :name, presence: true

  # Валидация email
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/,
              message: "имеет неверный формат"
            }

  # Валидация пароля
  validate :validate_password_complexity

  private

  def validate_password_complexity
    return if password.blank? # has_secure_password сам проверит наличие

    # Проверка длины
    if password.length < 8
      errors.add(:password, "должен содержать минимум 8 символов")
    end

    # Проверка наличия латинских букв
    unless password.match?(/[a-zA-Z]/)
      errors.add(:password, "должен содержать хотя бы одну латинскую букву")
    end

    # Проверка наличия цифр
    unless password.match?(/[0-9]/)
      errors.add(:password, "должен содержать хотя бы одну цифру")
    end

    # Запрет кириллицы
    if password.match?(/[а-яА-ЯёЁ]/)
      errors.add(:password, "не может содержать русские буквы")
    end
  end
end