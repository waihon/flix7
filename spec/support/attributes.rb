def movie_attributes(overrides = {})
  {
    title: "Iron Man",
    rating: "PG-13",
    total_gross: 318_412_101.00,
    description: "Tony Stark builds an armored suit to fight the throes of evil",
    released_on: "2008-05-02",
    director: "Jon Favreau",
    duration: "126 min",
    image_file_name: "ironman.png"
  }.merge(overrides)
end

def review_attributes(overrides = {})
  {
    stars: 3,
    comment: "I laughed, I cried, I spilled my popcorn!"
  }.merge(overrides)
end

def user_attributes(overrides = {})
  {
    name: "Example User",
    email: "user@example.com",
    password: "secretpassword",
    password_confirmation: "secretpassword",
    username: "example180"
  }.merge(overrides)
end