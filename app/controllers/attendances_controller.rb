class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:csv_output, :edit_one_month, :update_one_month, :edit_overtime_request_superior3, :edit_overtime_request_superior4, :change_of_attendance1,
  :change_of_attendance2, :designation_log, :one_month_request]
  before_action :logged_in_user, only: [:update, :edit_one_month, :edit_overtime_request, :update_overtime_request]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month, :edit_overtime_request]
  before_action :set_one_month, only: [:csv_output, :edit_one_month, :one_month_request]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  

  def new
    @attendance = Attendance.find(params[:id])
  
    # @user = User.find(params[:id])
  end
    
  
  def create
    # @attendance = Attendance.new(attendance_params)
    # @attendance.user_id = current_user.id
    # @attendance.save
    # redirect_to show
  end
  
  def csv_output
      respond_to do |format|
      format.html do
          #html用の処理を書く
      end 
      format.csv do
          #csv用の処理を書く
          send_data render_to_string, filename: "勤怠.csv", type: :csv
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
    
  end
  
  
  def update_one_month
     ActiveRecord::Base.transaction do 
       attendances_params.each do |id, item|
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
       end
    end
    flash[:success] = "勤怠の変更を申請しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  
  def edit_overtime_request
      @attendance = Attendance.find(params[:id])
  
    # @day=Date.parse(params[:day])s
    # @user=User.find(params[:id])
  end
  
  
  def update_overtime_request
       attendance = Attendance.find(params[:id])  
    if attendance.update(attendance_params)
      flash[:success] = "残業を申請しました。"
      redirect_to user_url(current_user)
    else
    end
  end
  
  
  def edit_overtime_request_superior3
     @users = User.joins(:attendances).group("users.id").where(attendances: {instructor:"1"})
     @attendance = Attendance.where(instructor:"1")
     
  end
  

  def update_overtime_request_superior3
  
      @attendances = Attendance.where(instructor:"1")
  # if @attendance.change == true
     
     if @attendances.update(attendances_params)
      flash[:success] = "残業申請の変更をしました"
      redirect_to user_url(current_user)
     else
      flash[:danger] = "変更にチェックを付けてください" 
      redirect_to user_url(current_user)
     end
  # end
  end
  
  
  def edit_overtime_request_superior4
     @users = User.joins(:attendances).group("users.id").where(attendances: {instructor:"2"})
     @attendance = Attendance.where(instructor:"2")
  end
  
  
  def update_overtime_request_superior4
         attendance = Attendance.find(params[:id])
   if attendance.change == "1" 
     if @attendance.update(attendance_params)
      flash[:success] = "勤怠の変更を確認しました。"
      redirect_to user_url(current_user)
      
     end
   end
  end
  
  
  def change_of_attendance1
    @users = User.joins(:attendances).group("users.id").where(attendances: {instructor1:"3"})
    @attendance = Attendance.where(instructor1:"3")
  end
  
  def update_change_of_attendance1
    
  end
  
  

  def change_of_attendance2
    @users = User.joins(:attendances).group("users.id").where(attendances: {instructor1:"4"})
    @attendance = Attendance.where(instructor1:"4")
  end
  
  def update_change_of_attendance2
    
  end
  
  
  def designation_log
    @attendance = Attendance.where(instructor: "1").or(Attendance.where(instructor1: "3")).where(user_id: @user)
  
  end
  
  
  
  def one_month_request
    
  end
  
  
  def update_one_month_request
    
  end
  
  

  
  
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
  end
  
  


  private
  
    def attendance_params
      params.require(:attendance).permit(:work_end_time, :day_after, :instructor, :instructor1, :job_description, :change, :request, :request1)
    end
    
    # def attendances_params
    #   params.require(:attendance).permit(:work_end_time, :overtime, :job_description, :change, :request1)
    # end
    
    
    
    
    
     
    def attendances_params
      params.require(:user).permit(attendances: [:begintime_at, :endtime_at, :note, :instructor, :instructor1])[:attendances] 
    end

end

