class StudentLabelSerializer < ActiveModel::Serializer
  attributes :id,
    :user_id,
    :student_id,
    :nickname,
end
