users = [
  { username: "sharky_j", avatar_url: "http://naserca.com/images/sharky_j.jpg", email: "sharky_j@gmail.com", password: "abcd" },
  { username: "kirk_whalum", avatar_url: "http://naserca.com/images/kirk_whalum.jpg", email: "kirk_w@gmail.com", password: "abcd" },
  { username: "marlin_peppa", avatar_url: "http://naserca.com/images/marlin_peppa.jpg", email: "marlin_p@gmail.com", password: "abcd" }
]

finstagram_posts = [
  { photo_url: "http://naserca.com/images/shark.jpg"},
  { photo_url: "http://naserca.com/images/whale.jpg"},
  { photo_url: "http://naserca.com/images/marlin.jpg"}
]

puts "=== Seeding database... ==="

# create Users and FinstagramPosts
users.each_with_index do |user, index|
  # create new User
  user_record = User.create(user)
  puts "-- Created User: #{user_record.username}"
  # get a finstagram_post
  finstagram_post = finstagram_posts[index]
  # modify finstagram_post's user_id from created record
  finstagram_post[:user_id] = user_record.id
  # create new FinstagramPost
  FinstagramPost.create(finstagram_post)
  puts "-- Created a FinstagramPost for User: #{user_record.username}"
end

puts "=== Seeding complete. ==="