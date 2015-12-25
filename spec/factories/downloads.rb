FactoryGirl.define do
  factory :download, class: 'Raindrops::Download' do
    destination_path "#{Rails.root.to_s.chomp('/spec/dummy')}/spec/files/to_download.zip"
    source_url 'http://ipv4.download.thinkbroadband.com/5MB.zip'
    status Raindrops::Download.statuses[:unprocessed]
  end

  trait :completed do
    destination_path "#{Rails.root.to_s.chomp('/spec/dummy')}/spec/files/download.txt"
    file_size 449
    status Raindrops::Download.statuses[:completed]
  end

  trait :uncompleted do
    destination_path "#{Rails.root.to_s.chomp('/spec/dummy')}/spec/files/download.txt"
    file_size 875
    status Raindrops::Download.statuses[:completed]
  end

  trait :with_invalid_destination_path do
    destination_path '/fdslkfd/vxcmlk/fdsmdmf'
  end

  trait :with_invalid_source_url do
    source_url 'http://fglgkfdmglgbmlfkmbmcvkbcbnvpobidfbodflbkcvxmlvkspdmjvfmdcxvbkxvmggv.com/'
  end
end
