FactoryGirl.define do
  factory :download, class: 'Raindrops::Download' do
    source_url 'http://dummy-url.com'
  end

  trait :completed do
    destination_path "#{Rails.root}/spec/files/completed.txt"
    status Raindrops::Download.statuses[:completed]
  end
end
