FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(sentence_count: 25) }
    image { 'https://cdn2.thecatapi.com/images/YfwpkuxH4.jpg' }
    user
    category
  end
end
