class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:csv_output, :edit_one_month, :update_one_month, :change_of_attendance1, :one_month_request]
  before_action :logged_in_user, only: [:update, :edit_one_month, :edit_overtime_request, :update_overtime_request]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month, :edit_overtime_request, :update_overtime_request,
  :edit_overtime_request_superior, :update_overtime_request_superior, :change_of_attendance1, :update_change_of_attendance1, :edit_one_month_request,
  :update_one_month_request, :designation_log]
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
    @request_count4 = 0
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        if item[:edit_authorizer].present?
          if item[:begintime_at].present? && item[:endtime_at].present? && item[:note].present? 
            attendance.edit_status = "申請中"
            attendance.update_attributes!(item)
          end
          if attendance.edit_status == "申請中"
          @request_count4 = @request_count4 + 1
          end
        end
      end
        flash[:success] = "勤怠の変更を合計#{@request_count4}件申請しました。"
        redirect_to user_url(date: params[:date])
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
    @request_count5 = 0
    @request_count6 = 0
    @request_count7 = 0
    @user = User.find(params[:user_id])
    @users = User.joins(:attendances).group("users.id").where(attendances: {overtime_status: "申請中", overtime_authorizer: @user.id})
    users_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:remember] == "true"
        if item[:overtime_status] == "なし"
            @request_count5 = @request_count5 + 1
        elsif item[:overtime_status] == "承認"
            @request_count6 = @request_count6 + 1
        elsif item[:overtime_status] == "否認"
            @request_count7 = @request_count7 + 1
        end
      @attendance.update(item)
      end
    end
    flash[:success] = "残業申請の#{@request_count5}件なし, #{@request_count6}件承認、#{@request_count7}件否認をしました。"
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
    @request_count8 = 0
    @request_count9 = 0
    @request_count10 = 0
    @user = User.find(params[:user_id])
    change_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:confirmed] == "true"
        if item[:edit_status] == "なし"
            @request_count8 = @request_count8 + 1
        elsif item[:edit_status] == "承認"
            @request_count9 = @request_count9 + 1
        elsif item[:edit_status] == "否認"
            @request_count10 = @request_count10 + 1
        end
      @attendance.update(item)  
      end
    end
    flash[:success] = "勤怠変更申請の#{@request_count8}件なし, #{@request_count9}件承認、#{@request_count10}件否認をしました。"
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
    @request_count11 = 0 
    @request_count12 = 0
    @request_count13 = 0
    @user = User.find(params[:user_id])
    one_month_request_params.each do |id, item|
      @attendance = Attendance.find(id)
      if item[:verify] == "true"
        if item[:month_req_status] == "なし"
            @request_count11 = @request_count11 + 1
        elsif item[:month_req_status] == "承認"
            @request_count12 = @request_count12 + 1
        elsif item[:month_req_status] == "否認"
            @request_count13 = @request_count13 + 1
        end
      @attendance.update(item)
      end
    end  
    flash[:success] = "１ヶ月の申請を合計#{@request_count11}件なし, #{@request_count12}件承認、#{@request_count13}件否認をしました。"
    redirect_to user_url(current_user)
  end
  

  def designation_log
    if params["search(1i)"] || params["search(2i)"] || params["search(3i)"] == present?
      @user = User.find(params[:user_id])
      @attendances = @user.attendances.where(edit_status: "承認").where(worked_on: params["search(1i)"]+'-'+params["search(2i)"]+'-'+params["search(3i)"]..params["search(1i)"]+'-'+params["search(2i)"]+'-'+"30").order(worked_on: "ASC")
        if @attendances == []
          flash.now[:danger] = "勤怠ログはありません"
          render :designation_log
        end
    else
     @attendances = @user.attendances.where(edit_status: "承認")  
    end
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
      unless current_user?(@user) 
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end

end

