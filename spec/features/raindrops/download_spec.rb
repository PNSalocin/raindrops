require 'spec_helper'

feature 'test', download: true, js: true do

  background {
    visit '/raindrops'
  }

  scenario 'truc' do
    sleep 100
    expect(true).to eq true
  end
end