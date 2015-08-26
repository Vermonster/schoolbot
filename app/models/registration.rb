class Registration
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include ActiveModel::ForbiddenAttributesProtection

  attr_accessor :terms_accepted
  validates :terms_accepted, acceptance: { accept: true }

  REGISTRATION_ATTRIBUTES = %i(terms_accepted)
  STUDENT_LABEL_ATTRIBUTES = %i(digest nickname school_id)
  USER_ATTRIBUTES =
    %i(email password password_confirmation name street city state zip_code)
  ATTRIBUTES =
    REGISTRATION_ATTRIBUTES + STUDENT_LABEL_ATTRIBUTES + USER_ATTRIBUTES

  USER_ATTRIBUTES.each do |attribute|
    delegate attribute, "#{attribute}=", to: :user
  end
  STUDENT_LABEL_ATTRIBUTES.each do |attribute|
    delegate attribute, "#{attribute}=", to: :student_label
  end

  delegate :id, to: :user

  def initialize(district:, attributes: {})
    self.user = district.users.new
    self.student_label = user.student_labels.new
    super(attributes)
  end

  def save
    if valid?
      user.save
    else
      false
    end
  end

  def errors
    errors = super
    user.errors.each do |attribute, error|
      errors.add(attribute, error) unless errors.added?(attribute, error)
    end
    student_label.errors.each do |attribute, error|
      errors.add(attribute, error) unless errors.added?(attribute, error)
    end
    errors.delete(:student_labels) # https://github.com/rails/rails/pull/16321
    errors
  end

  def valid?(context = nil)
    [super, user.valid?(context), student_label.valid?(context)].all?
  end

  private

  attr_accessor :user, :student_label
end
