require "rails_helper"

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
      expect(post["title"]).to eq(post["title"])
      expect(post["image"]).to eq("https://i.picsum.photos/id/852/200/300.jpg?hmac=6IMZOkPF_q5nf8IwfYdfxPUyKnyPL1w8moDjTeMOT5g")
    end
  end
  describe "POST /posts" do
    it "creates new post" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      jwt = JWT.encode(
        {
          user_id: user.id, # the data to encode
          exp: 24.hours.from_now.to_i,
        },
        Rails.application.credentials.fetch(:secret_key_base), # the secret key
        "HS256"
      )

      post "/posts", params: {
                       user_id: user.id,
                       title: "title test",
                       body: "body test",
                       image: "image string test",
                     },
                     headers: { "Authorization" => "Bearer #{jwt}" }

      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("title test")
      expect(post["body"]).to eq("body test")
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
