# TermsController
class UsersController < ApplicationController
  before_action :set_elevated_users, only: [:index, :list_generic_users]
  authorize_resource
  layout 'administration'

  def index
    @generic_users_count = User.count - @elevated_users.count
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update(user_params)
    @errors = @user.errors
  end

  def elevate
    @errors = {}
    @user = User.find(elevate_params[:id])
    admin = elevate_params[:admin] == '1'
    return unless admin
    if @user.name.blank?
      name = @user.email.split('@')[0]
      @user.update(admin: true, name: name)
    else
      @user.update(admin: true)
    end
  end

  def list_generic_users
    @generic_users = User.all.to_a - @elevated_users
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy unless @user.admin || @user.editor? || @user.teacher?
    redirect_to users_path
  end

  def teacher
    @teacher = User.find_by_id(params[:teacher_id])
    if @teacher.present? && @teacher.teacher?
      render layout: 'application'
      return
    end
    redirect_to :root,
                alert: 'Ein(e) DozentIn mit der angeforderten id existiert ' \
                       'nicht.'
  end

  private

  def elevate_params
    params.require(:generic_user).permit(:id, :admin, :editor, :teacher, :name)
  end

  def user_params
    params.require(:user).permit(:name, :email, :admin, :homepage)
  end

  def set_elevated_users
    @elevated_users = User.where(admin: true).to_a | User.editors |
                      User.teachers
  end
end
