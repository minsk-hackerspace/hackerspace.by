FactoryBot.define do
  factory :news do
    title { 'Title' }
    user
    markup_type { News::SUPPORTED_MARKUPS.first }
    show_on_homepage_till_date { Time.now + 1.day }
  end
end
