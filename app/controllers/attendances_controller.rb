class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:csv_output, :edit_one_month, :update_one_month, :change_of_attendance1, :designation_log, :one_month_request]
  before_action :logged_in_user, only: [:update, :edit_one_month, :edit_overtime_request, :update_overtime_request]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month, :edit_overtime_request]
  before_action :set_one_month, only: [:csv_output, :edit_one_month, :one_month_request]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  

  def new
    @attendance = Attendance.find(params[:id])
  end

  def create
    
  end
  
  def show
    
  end
  
  def index
  
  end
  
  def csv_output
      respond_to do |format|
      format.html do
          #html用の処理を書く
      end 
      format.csv do
          #csv用の処理を書く
          send_data render_to_string, filename: "#{@user.name}.csv", type: :csv
      end
    end
  end
  

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
     @instructor = User.where(superior: true).where.not(id: @user.id)
  end
  
  # 勤怠を編集
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:edit_authorizer].present?
          if item[:begintime_at].present? && item[:endtime_at].present? && item[:note].present? 
            attendance.edit_status = "申請中"
            attendance.update_attributes!(item)
            flash[:success] = "勤怠の変更を申請しました。"
            # redirect_to user_url(date: params[:date])and return
             redirect_to attendances_edit_one_month_user_url(date: params[:date])and return
          else
            flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
            # redirect_to user_url(date: params[:date])and return
            redirect_to attendances_edit_one_month_user_url(date: params[:date])and return
          end
        else
          flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
          redirect_to attendances_edit_one_month_user_url(date: params[:date])and return
        end
      end
    end
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  # 残業申請モーダル表示
  def edit_overtime_request
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    @instructor = User.where(superior: true).where.not(id: @user.id)
  end
  
  # 残業申請
  def update_overtime_request
    attendance = Attendance.find(params[:id]) 
    attendance.overtime_status = "申請中"
    if attendance.update(attendance_params)
       flash[:success] = "残業を申請しました。"
       redirect_to user_url(current_user) 
    end
  end
  
  # 上長への残業申請のお知らせモーダル表示
  def edit_overtime_request_superior
     @user = User.find(params[:user_id])
     @users = User.joins(:attendances).group("users.id").where(attendances: {overtime_status: "申請中", overtime_authorizer: @user.id})
     @attendances = Attendance.where(overtime_authorizer: @user.id, overtime_status: "申請中")
  end
  
  # 残業申請による上長からの承認または否認の返信
  def update_overtime_request_superior
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: {overtime_status: "申請中", overtime_authorizer: @user.id})
    users_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:remember] == "true"
        @attendance.update(item)
      end
    end
    flash[:success] = "残業申請の変更をしました"
    redirect_to user_url(current_user)
  end

  # 上長への勤怠変更申請モーダル表示
  def change_of_attendance1
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: {edit_status: "申請中", edit_authorizer: @user.id})
    @attendances = Attendance.where(edit_authorizer: @user.id, edit_status: "申請中")

  end
  
  # 勤怠変更申請による上長からの承認または否認の返信
  def update_change_of_attendance1
    @user = User.find(params[:user_id])
    # @users = User.joins(:attendances).group("users.id").where(attendances: {edit_status: "申請中", edit_authorizer: @user.id})
      change_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:confirmed] == "true"
        @attendance.update(item)
      end
    end
    flash[:success] = "勤怠編集の変更をしました"
    redirect_to user_url(current_user)
  end

  # 一ヶ月分の勤怠申請モーダル
  def edit_one_month_request
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: {month_req_status: "申請中", month_req_authorizer: @user.id})
    @attendances = Attendance.where(month_req_authorizer: @user.id, month_req_status: "申請中")

  end
  
  # 一ヶ月分の勤怠申請の承認または否認
  def update_one_month_request
    @user = User.find(params[:user_id])
    one_month_request_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:verify] == "true"
        @attendance.update(item)
      end
    end
      flash[:success] = "１ヶ月の申請の変更をしました"
      redirect_to user_url(current_user)
  end
  

  def designation_log
    @user = User.find(params[:user_id])
    @search = @user.attendances.where(edit_status: "承認").order(worked_on: "ASC").ransack(params[:q])
    @attendances = @search.result
  end


  private
  
    def attendance_params
      params.require(:attendance).permit(:work_end_time, :day_after, :overtime_authorizer, :job_description)
    end
    
    def users_params
      params.require(:attendance).permit(attendance: [:overtime, :job_description, :remember, :overtime_status])[:attendance]
    end
    
    def attendances_params
      params.require(:user).permit(attendances: [:begintime_at, :endtime_at, :note, :edit_authorizer, :edit_status, :tomorrow])[:attendances] 
    end
    
    def change_params
      params.require(:user).permit(attendances: [:edit_status, :confirmed])[:attendances]
      
    end
    
    def one_month_request_params
      params.require(:user).permit(attendances: [:verify, :month_req_status])[:attendances]
    end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end

end

