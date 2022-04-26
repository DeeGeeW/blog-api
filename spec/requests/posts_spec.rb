require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns an array of posts" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/852/200/300.jpg?hmac=6IMZOkPF_q5nf8IwfYdfxPUyKnyPL1w8moDjTeMOT5g")
      Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/135/200/300.jpg?hmac=d3sTOCUkxdC1OKCgh9wTPjck-gMWATyVHFvflla5vLI")



      get "/posts"
      posts = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(2)
    end
  end
  describe "GET posts/:id" do
    it "show if post attributes work correctly" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")
      
      post = Post.create!(user_id: user.id, title: Faker::Company.catch_phrase, body: Faker::Hipster.paragraph(sentence_count: 6), image: "https://i.picsum.photos/id/852/200/300.jpg?hmac=6IMZOkPF_q5nf8IwfYdfxPUyKnyPL1w8moDjTeMOT5g")

      get "/posts/#{post.id}"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["user_id"]).to eq(user.id)
      # expect(post["title"]).to eq(Faker::Company.catch_phrase)
      expect(post["image"]).to eq("https://i.picsum.photos/id/852/200/300.jpg?hmac=6IMZOkPF_q5nf8IwfYdfxPUyKnyPL1w8moDjTeMOT5g")
    end
  end
end
# RSpec.describe "Users", type: :request do
#   describe "GET /users" do
#     it "returns an array of users" do
      
#       User.create!(name: "Peter", email: "peter@test.com", password: "password")
#       User.create!(name: "Test", email: "test@test.com", password: "password")

#       get "/users"
#       users = JSON.parse(response.body)
#       expect(response).to have_http_status(200)
#       expect(users.length).to eq(2)
#     end
#   end
# end

  


