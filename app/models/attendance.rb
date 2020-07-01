class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
 

  # 出勤時間が存在しない場合、退勤時間は無効
  # validate :finished_at_is_invalid_without_a_started_at
  # validate :begintime_at_is_invalid_without_a_endtime_at
  # 退勤時間が存在しない場合、出勤時間は無効
  # validate :started_at_is_invalid_without_a_finished_at
  # validate :begintime_at_is_invalid_without_a_endtime_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  # validate :started_at_than_finished_at_fast_if_invalid
  # validate :begintime_at_than_endtime_at_fast_if_invalid

  # def endtime_at_is_invalid_without_a_begintime_at
  #   errors.add(:begintime_at, "が必要です") if begintime_at.blank? && endtime_at.present? 
  # end
  
  # def begintime_at_is_invalid_without_a_endtime_at
  #   errors.add(:endtime_at, "が必要です") if endtime_at.blank? && begintime_at.present? && worked_on != Date.current
  # end
  
  # def begintime_at_than_endtime_at_fast_if_invalid
  #   if begintime_at.present? && endtime_at.present?
  #     errors.add(:begintime_at, "より早い退勤時間は無効です") if begintime_at > endtime_at
  #   end
  # end

end
