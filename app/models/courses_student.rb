class CoursesStudent < ApplicationRecord
    belongs_to :students
    belongs_to :teacher
end
