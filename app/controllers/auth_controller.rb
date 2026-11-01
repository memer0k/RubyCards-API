class AuthController < ApplicationController
  # Метод для регистрации
  def register
    user = User.new(user_params)

    if user.save
      render json: {
        message: "Регистрация успешна",
        user: {
          id: user.id,
          name: user.name,
          email: user.email
        },
        auth_token: user.auth_token
      }, status: :created
    else
      # Форматируем ошибки для клиента
      errors = format_errors(user.errors)
      render json: {
        error: "Ошибка регистрации",
        details: errors
      }, status: :unprocessable_entity
    end
  end

  # Метод для авторизации
  def login
    email = params[:email]
    password = params[:password]

    # Проверяем наличие обязательных полей
    if email.blank? || password.blank?
      render json: {
        error: "Email и пароль обязательны"
      }, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: email)

    if user&.authenticate(password)
      render json: {
        message: "Вход выполнен",
        user: {
          id: user.id,
          name: user.name,
          email: user.email
        },
        auth_token: user.auth_token
      }, status: :ok
    else
      # Не раскрываем, существует ли email (безопасность)
      render json: {
        error: "Неверный email или пароль"
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def format_errors(errors)
    formatted = {}
    errors.each do |error|
      field = error.attribute.to_sym
      message = error.message

      # Создаём массив сообщений для поля, если его ещё нет
      formatted[field] ||= []
      formatted[field] << message
    end
    formatted
  end
end