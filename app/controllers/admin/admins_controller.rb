class Admin::AdminsController < AdminController

  before_action :reset_password, except: %i(update)

  def index
    respond_to do |format|
      format.html
      format.json { render json: AdminDatatable.new(view_context) }
    end
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    redirect_to edit_admin_admin_path(@admin.id), notice: 'Новый администратор создан.' if @admin.save
  end

  def edit
    @admin = Admin.find_by(id: params[:id])
  end

  def update
    @admin = Admin.find_by(id: params[:id])
    if @admin.update_attributes(admin_params)
      @admin.update_column(:is_password_changed, true) unless @admin.is_password_changed
      redirect_to edit_admin_admin_path(@admin.id), notice: 'Данные успешно обновлены.'
    end
  end

  def destroy
    @admin = Admin.find_by(id: params[:id]).destroy
    redirect_to admin_admins_path, notice: "Администратор - #{@admin.email}, удален."
  end

  private

  def admin_params
    params.require(:admin).permit!.except(:id)
  end
end
