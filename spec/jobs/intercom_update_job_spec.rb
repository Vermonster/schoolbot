require 'rails_helper'

describe IntercomUpdateJob do
  def perform(model)
    described_class.perform_now(model)
  end

  it 'updates Intercom with company data when passed a district' do
    stub = stub_request(:post, %r{api\.intercom\.io/companies})

    perform(District.new)

    expect(stub).to have_been_requested.once
  end

  it 'updates Intercom with user data when passed a non-destroyed user' do
    stub = stub_request(:post, %r{api\.intercom\.io/users})

    perform(User.new)

    expect(stub).to have_been_requested.once
  end

  it 'destroys the user record in Intercom when passed a destroyed user' do
    get_stub = stub_request(:get, %r{api\.intercom\.io/users}).to_return(
      body: { type: 'user', id: '1' }.to_json
    )
    delete_stub = stub_request(:delete, %r{api\.intercom\.io/users})
    user = User.new
    allow(user).to receive(:destroyed?).and_return(true)

    perform(user)

    expect(get_stub).to have_been_requested.once
    expect(delete_stub).to have_been_requested.once
  end
end
