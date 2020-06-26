class Office < ApplicationRecord
    validates :office_name, presence: true
    validates :office_number, presence: true
    validates :attendance_type, presence: true
end
