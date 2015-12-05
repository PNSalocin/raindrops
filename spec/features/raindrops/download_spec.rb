require 'spec_helper'

feature 'test', download: true, js: true do
  background {
    visit '/raindrops'
  }

  scenario 'truc' do
    expect(page).to have_content "Raindrops #{Raindrops::VERSION}"
  end
end
