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
  
  
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  

  def over_time(work_end_time, designation_duty_finish_time, day_after)
  #   @user = User.find(params[:id])
  #   @attendance = Attendance.find(params[:id])
  #   work_end = @user.designation_duty_finish_time.change(month: @attendance.worked_on.month, day: @attendance.worked_on.day)
  #   finish = @attendance.work_end_time.change(month: @attendance.worked_on.month, day: @attendance.worked_on.day)
  #   # if day_after == false
  #   format("%.2f", ((( work_end -  finish ) / 60) / 60.0) )
  #   # else
  #   format("%.2f", ((( work_end -  finish ) / 60) / 60.0) + 24)
  # # 　end　　
  end
end  