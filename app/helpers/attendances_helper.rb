module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end
  
  
  def working_times(start, finish, worked_on)
    @user = User.find(params[:id])
    @attendance = @user.attendances.find_by(worked_on: worked_on)
    if @attendance.tomorrow == "false"
    format("%.2f", ((( finish - start) / 60) / 60.0))  
    else
    format("%.2f", ((( finish - start ) / 60) / 60.0) + 24)
    end  
  end
  
    # 残業時間
  def overtime(work_end_time, designation_duty_finish_time, worked_on)
    @user = User.find(params[:id])
    @attendance = @user.attendances.find_by(worked_on: worked_on)
    work_end = @user.designation_duty_finish_time.change(year: worked_on.year, month: worked_on.month, day: worked_on.day)
    finish = @attendance.work_end_time.change(year: worked_on.year, month: worked_on.month, day: worked_on.day)
    if @attendance.day_after == false
    format("%.2f", ((( finish -  work_end ) / 60) / 60.0) )
    else
    format("%.2f", ((( finish -  work_end ) / 60) / 60.0) + 24)
    end
  end
  
end  
  
