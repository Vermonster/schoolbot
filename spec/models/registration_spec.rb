require 'rails_helper'

describe Registration do
  describe '#errors' do
    it 'collects errors from the associated user and student label' do
      allow_any_instance_of(User).to receive(:errors).and_return(foo: 'bar')
      allow_any_instance_of(StudentLabel)
        .to receive(:errors).and_return(baz: 'qux')

      registration = Registration.new(district: build(:district))

      expect(registration.errors[:foo]).to eq ['bar']
      expect(registration.errors[:baz]).to eq ['qux']
    end

    it 'suppresses association errors propagated from the student_label' do
      allow_any_instance_of(User)
        .to receive(:errors).and_return(student_labels: 'boop')
      allow_any_instance_of(StudentLabel).to receive(:errors).and_return({})

      registration = Registration.new(district: build(:district))

      expect(registration.errors).to be_empty
    end
  end

  describe '#save' do
    it 'returns false when the registration is invalid' do
      registration = Registration.new(district: build(:district))
      allow(registration).to receive(:valid?).and_return(false)
      allow_any_instance_of(User).to receive(:save).and_raise('should not save')

      expect(registration.save).to be false
    end

    it 'saves the associated user and sends a confirmation email' do
      user = double
      confirmation_email = double
      registration = Registration.new(district: build(:district))
      allow(registration).to receive(:valid?).and_return(true)
      allow(registration).to receive(:user).and_return(user)
      allow(user).to receive(:save!).and_return('saved!')
      allow(ConfirmationMailer)
        .to receive(:confirmation).and_return(confirmation_email)
      allow(confirmation_email).to receive(:deliver_later).and_return(true)

      expect(registration.save).to be true
      expect(user).to have_received(:save!)
      expect(confirmation_email).to have_received(:deliver_later)
    end
  end

  describe '#valid?' do
    it 'returns true if all associated objects are valid' do
      allow_any_instance_of(User).to receive(:valid?).and_return(true)
      allow_any_instance_of(StudentLabel).to receive(:valid?).and_return(true)

      registration = Registration.new(district: build(:district))

      expect(registration).to be_valid
    end

    it 'returns false if any associated objects are invalid' do
      allow_any_instance_of(User).to receive(:valid?).and_return(false)
      allow_any_instance_of(StudentLabel).to receive(:valid?).and_return(true)

      registration = Registration.new(district: build(:district))

      expect(registration).to_not be_valid
    end
  end
end
