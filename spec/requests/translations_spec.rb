require 'rails_helper'

describe 'Translations API' do
  it 'exposes translations for locales that have a localeName key' do
    # TODO: Find a way to stub the translation data itself
    allow(I18n).to receive(:available_locales).and_return(%i[en zh fake])
    allow(I18n).to receive(:exists?).with('localeName', :en).and_return(true)
    allow(I18n).to receive(:exists?).with('localeName', :zh).and_return(true)
    allow(I18n).to receive(:exists?).with('localeName', :fake).and_return(false)
    allow(I18n).to receive(:t).with('.', locale: :en).and_return(hello: 'Hello')
    allow(I18n).to receive(:t).with('.', locale: :zh).and_return(hello: '您好')

    get api_translations_url

    expect(response).to be_successful
    expect(response_json.keys).to eq %i[en zh]
    expect(response_json[:en]).to eq(hello: 'Hello')
    expect(response_json[:zh]).to eq(hello: '您好')
  end
end
