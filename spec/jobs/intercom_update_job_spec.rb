require 'rails_helper'

describe IntercomUpdateJob do
  def perform(*arguments)
    described_class.perform_now(*arguments)
  end

  it 'updates Intercom with district data' do
    stub = stub_request(:post, %r{api\.intercom\.io/companies})

    perform('update_district', District.new)

    expect(stub).to have_been_requested.once
  end

  it 'updates Intercom with user data' do
    stub = stub_request(:post, %r{api\.intercom\.io/users})

    perform('update_user', User.new)

    expect(stub).to have_been_requested.once
  end

  it 'destroys a user record in Intercom' do
    get_stub = stub_request(:get, %r{api\.intercom\.io/users}).to_return(
      body: { type: 'user', id: '1' }.to_json
    )
    delete_stub = stub_request(:delete, %r{api\.intercom\.io/users})

    perform('destroy_user', 1)

    expect(get_stub).to have_been_requested.once
    expect(delete_stub).to have_been_requested.once
  end

  it 'raises an error when passed an invalid action' do
    expect { perform('invalid_action') }.to raise_error ArgumentError
  end
end
