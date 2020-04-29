class Office < ApplicationRecord
    validates :office_name, presence: true
    validates :office_number, presence: true
end
