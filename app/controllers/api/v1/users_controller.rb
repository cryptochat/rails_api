class Api::V1::UsersController < ApiController
  def create
    @user = User.new(user_params)
    @user.tokens.build
    if @user.save
      json = {}
      json[:status] = 'Created'
      json[:data] = serialize_encrypt_data(@user, :uuid, :email, :username, :first_name, :last_name, :token)
      render json: json, status: :created
    else
      serialize_errors(@user.errors)
    end
  end

  def auth
    unless user_params[:email].present? || user_params[:username].present?
      return respond_with 400, key: 'login', message: 'email or username not present'
    end

    unless user_params[:password].present?
      return respond_with 400, key: 'password', message: 'password not present'
    end

    login = user_params[:email].present? ? user_params[:email] : user_params[:username]
    @user = User.auth(login, user_params[:password])

    return respond_with 404, key: 'user', message: 'User with the given username and password was not found' unless @user.present?

    json = {}
    json[:status] = 'OK'
    json[:data] = serialize_encrypt_data(@user, :uuid, :email, :username, :first_name, :last_name, :token)
    render json: json, status: :ok
  end

  private

  def user_params
    $params.permit(:email, :password, :first_name, :last_name, :username)
  end
end
