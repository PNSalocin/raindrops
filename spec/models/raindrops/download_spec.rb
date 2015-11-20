require 'spec_helper'

describe Raindrops::Download, type: :model do
  subject(:download_completed) { create :models, :completed }
  subject(:download_unprocessed) { create :models }
  subject(:download_uncompleted) { create :models, :uncompleted }
  subject(:download_with_invalid_destination_path) { create :models, :with_invalid_destination_path }
  subject(:download_with_invalid_source_url) { create :models, :with_invalid_source_url }

  it 'has valid factories' do
    expect(build(:models, :completed)).to be_valid
  end

  context '.bytes_downloaded' do
    context 'with valid path' do
      it 'return correct file size' do
        expect(download_completed.bytes_downloaded).to eq 449
      end
    end

    context 'with invalid path' do
      it 'return a file size of 0' do
        expect(download_with_invalid_destination_path.bytes_downloaded).to eq 0
      end
    end
  end

  context '.progress' do
    context 'with completed download' do
      it 'return correct progress' do
        expect(download_completed.progress).to eq 100.0
      end
    end

    context 'with uncompleted download' do
      it 'return correct progress' do
        expect(download_uncompleted.progress).to eq 51.31
      end
    end

    context 'with invalid download' do
      it 'return a progress of 0' do
        expect(download_with_invalid_destination_path.progress).to eq 0
      end
    end
  end

  context '.download' do
    context 'with valid url' do
      context 'and valid path' do
        it 'download file' do
          download_unprocessed.start
          expect(File.exist? download_unprocessed.destination_path).to eq true
          expect(File.size download_unprocessed.destination_path).to eq 5_242_880
          expect(download_unprocessed.completed?).to eq true
        end
      end

      after {
        File.delete download_unprocessed.destination_path if File.exist? download_unprocessed.destination_path
      }

      context 'and invalid path' do
        it 'won\'t download file' do
          download_with_invalid_destination_path.start
          expect(File.exist? download_with_invalid_destination_path.destination_path).to eq false
          expect(download_with_invalid_destination_path.error_opening_destination_file?).to eq true
        end
      end
    end

    context 'with invalid url' do
      it 'won\'t download file' do
        download_with_invalid_source_url.start
        expect(File.exist? download_with_invalid_source_url.destination_path).to eq false
        expect(download_with_invalid_source_url.error_downloading_source_file?).to eq true
      end
    end
  end
end
