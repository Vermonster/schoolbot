require 'rails_helper'

describe 'Translations API' do
  it 'exposes translations for all locales except the "api" pseudo-locale' do
    # TODO: Find a way to stub the translation data itself
    allow(I18n).to receive(:available_locales).and_return([:en, :es, :api])
    allow(I18n).to receive(:t).with('.', locale: :en).and_return(hello: 'Hello')
    allow(I18n).to receive(:t).with('.', locale: :es).and_return(hello: 'Hola')

    get api_translations_url

    expect(response).to be_successful
    expect(response_json.keys).to eq [:en, :es]
    expect(response_json[:en]).to eq(hello: 'Hello')
    expect(response_json[:es]).to eq(hello: 'Hola')
  end
end
