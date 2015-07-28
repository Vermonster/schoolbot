class StudentLabelSerializer < ActiveModel::Serializer
  has_one :school
  attributes :id, :nickname
end
