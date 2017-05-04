module Api::V1
  # Контроллер отвечающий за регистрацию/аунтификацию пользователей
  class UsersController < ApiController
    before_action :auth_by_token, except: %w(create auth)

    def index
      @users = if search_params[:query].present?
                 User.search(search_params[:query]).where.not(id: current_user.id)
               else
                 User.all.where.not(id: current_user.id)
               end
    end

    def create
      @user = User.new(user_params)
      @user.tokens.build
      if @user.save
        render 'api/v1/users/auth', status: :created
      else
        serialize_errors(@user.errors)
      end
    end

    def update
      @user = current_user
      if @user.update_attributes(update_params)
        render status: :ok
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

      unless @user.present?
        return respond_with 404, key: 'user', message: 'User with the given username and password was not found'
      end

      render status: :ok
    end

    private

    def user_params
      CurrentConnection.instance.params.permit(:email, :password, :first_name, :last_name, :username)
    end

    def update_params
      CurrentConnection.instance.params.permit(:password, :first_name, :last_name, :avatar)
    end

    def search_params
      CurrentConnection.instance.params.permit(:query)
    end
  end
end
