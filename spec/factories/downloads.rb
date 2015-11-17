FactoryGirl.define do
  factory :models, class: 'Raindrops::Download' do
    destination_path "#{Raindrops::Support::Utils.rails_true_root}/spec/files/to_download.zip"
    source_url 'http://ipv4.download.thinkbroadband.com/5MB.zip'
    status Raindrops::Download.statuses[:unprocessed]
  end

  trait :completed do
    destination_path "#{Raindrops::Support::Utils.rails_true_root}/spec/files/download.txt"
    file_size 449
    status Raindrops::Download.statuses[:completed]
  end

  trait :uncompleted do
    destination_path "#{Raindrops::Support::Utils.rails_true_root}/spec/files/download.txt"
    file_size 875
    status Raindrops::Download.statuses[:completed]
  end

  trait :with_invalid_destination_path do
    destination_path '/fdslkfdslmkfdsmlfksdmlfksdlmfm/vclkxmvlkxcmlk/fdsmlfsdmf'
  end

  trait :with_invalid_source_url do
    source_url 'http://fglgkfdmglgbmlfkmbmcvkbcbnvpobidfbodflbkcvxmlvkspdmjvfmdcxvbkxvmggv.com/'
  end
end
