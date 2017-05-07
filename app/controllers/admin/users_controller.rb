class Admin::UsersController < AdminController
  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    redirect_to edit_admin_user_path(@user.id), notice: 'Новый пользователь создан.' if @user.save
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    redirect_to edit_admin_user_path(@user.id), notice: 'Данные пользователя обновлены.' if @user.update_attributes(users_params)
  end

  def destroy
    @user = User.find_by(id: params[:id]).destroy
    redirect_to admin_users_path, notice: "Пользователь - #{@user.full_name}, удален."
  end

  private

  def users_params
    params.require(:user).permit!.except(:id)
  end
end
