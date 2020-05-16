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
  
  def over_time(work_end_time, designation_duty_finish_time)
    format("%.2f", (((designation_duty_finish_time - work_end_time ) / 60) / 60.0))
  end
  
  
  def request_count1
    Attendance.where(instructor:"1").count
  
  end
  
  def request_count2
    Attendance.where(instructor:"2").count
  end
  
  
  
  
  
  
  
end


