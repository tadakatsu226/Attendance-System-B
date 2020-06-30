class Office < ApplicationRecord
    validates :office_name, presence: true, length: { maximum: 10 }
    validates :office_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
    validates :attendance_type, presence: true
end
