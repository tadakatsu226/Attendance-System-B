require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(日時 出社 退社)
  csv << csv_column_names
  @attendances.each do |attendance|
    column_values = [
      attendance.worked_on,
      if attendance.started_at.present? 
        if attendance.begintime_at.present?
           attendance.begintime_at.strftime("%H:%M") 
        else
           attendance.started_at.strftime("%H:%M")
        end 
      elsif attendance.edit_status == "承認"
           attendance.begintime_at.strftime("%H:%M") 
      end,
      if attendance.finished_at.present? 
        if attendance.endtime_at.present?
           attendance.endtime_at.strftime("%H:%M") 
        else
           attendance.finished_at.strftime("%H:%M")
        end 
      elsif attendance.edit_status == "承認"
           attendance.endtime_at.strftime("%H:%M") 
      end  
    ]
    csv << column_values
  end
end