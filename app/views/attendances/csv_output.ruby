require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(日時 出勤 退勤)
  csv << csv_column_names
  @attendances.each do |attendance|
    column_values = [
      attendance.worked_on,
      if attendance.started_at.present?
      attendance.started_at.strftime("%H:%M")
      end,
      if attendance.finished_at.present?
      attendance.finished_at.strftime("%H:%M")
      end  
    ]
    csv << column_values
  end
end