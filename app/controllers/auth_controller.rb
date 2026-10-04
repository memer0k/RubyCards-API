class AuthController < ApplicationController
  # Метод для регистрации
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: "Регистрация успешна", user: { id: user.id, name: user.name, email: user.email } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Метод для авторизации
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { message: "Вход выполнен", user: { id: user.id, name: user.name, email: user.email } }, status: :ok
    else
      render json: { error: "Неверный email или пароль" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end