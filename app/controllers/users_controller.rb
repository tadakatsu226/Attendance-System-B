class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_basic_info, :check_show]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :destroy, :going_to_work]
  before_action :admin_or_correct_user, only: [:edit, :update]
  before_action :set_one_month, only: [:show, :check_show]
  before_action :admin_or_correct_user, only: :show
  before_action :not_admin_user, only: :show


  def index
    @users = User.where.not(id: 1).all
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @instructor = User.where(superior: true).where.not(id: @user.id)
    @request_count1 = Attendance.where(month_req_authorizer: @user.id, month_req_status: "申請中").count
    @request_count2 = Attendance.where(edit_authorizer: @user.id, edit_status: "申請中").count
    @request_count3 = Attendance.where(overtime_authorizer: @user.id, overtime_status: "申請中").count
  end
  
  
  def check_show
   
  end
  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @user.update_attributes(user_info_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
      redirect_to users_url
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end


  def going_to_work
     @users = User.joins(:attendances).group("users.id").where.not(attendances: {started_at: nil}).where(attendances: {finished_at: nil}) 
  end
  

  def import
    if params[:file].blank?
      redirect_to users_url  
      flash[:danger] = "ファイルが選択されていません。"
    else
     User.import(params[:file])
      redirect_to users_url
      flash[:success] = "CSVインポートに成功しました。"
    end  
  end
  

  # 一ヶ月分の勤怠申請
  def update_one_month_application
    @user = User.find(params[:user_id])
    attendance = @user.attendances.find_by(worked_on: params[:attendance][:apply_month])
    attendance.month_req_status = "申請中"
    if attendance.update(one_month_params)
      flash[:success] = "１ヶ月の勤怠を申請しました。"
      redirect_to user_url(current_user)
    end  
  end
  

  private
  

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation)
    end

    def user_info_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :employee_number, :uid,
      :basic_time, :designation_duty_start_time, :designation_duty_finish_time)
    end
    
    def one_month_params
      params.require(:attendance).permit(:month_req_status, :apply_month, :month_req_authorizer)
    end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
    
    def not_admin_user
      if current_user.admin?
      # flash[:danger] = "管理者には勤怠画面を閲覧できません"
      redirect_to users_url
      end
    end

end