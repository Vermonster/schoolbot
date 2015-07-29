class BusAssignment < ActiveRecord::Base
  belongs_to :bus
  belongs_to :student
end
