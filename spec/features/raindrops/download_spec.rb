require 'spec_helper'

feature 'manage downloads', features: true, download: true, js: true do
  background {
    Raindrops::Download.all.each do |download|
      download.destroy
    end

    @download_completed = create :download, :completed
    @download_unprocessed = create :download
    @download_uncompleted = create :download, :uncompleted

    visit '/raindrops'
  }

  scenario 'see all downloads' do
    expect(page).to have_content "Raindrops #{Raindrops::VERSION}"

    expect_row_data @download_completed
    expect_row_data @download_unprocessed
    expect_row_data @download_uncompleted
  end

  # blabla
  def expect_row_data(download)
    element = find("#download-#{download.id}")
    expect(element).to have_content download.bytes_downloaded
    expect(element).to have_content download.file_size
    expect(element).to have_content download.progress
  end
end
