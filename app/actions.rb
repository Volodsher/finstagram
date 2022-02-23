helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

# get '/' do
#   File.read(File.join('app/views', 'index.html'))
# end
# get '/1' do
#   File.read(File.join('app/views', 'in.html'))
# end
# get '/12' do
#   "Hello world"
# end

# def humanized_time_ago(time_ago_in_minutes)
#   if time_ago_in_minutes >= 60
#     "#{time_ago_in_minutes / 60} hours ago"
#   else
#     "#{time_ago_in_minutes} minutes ago"
#   end
# end

# get '/' do
#   @finstagram_post_shark = {
#     username: "sharky_j",
#     avatar_url: "http://naserca.com/images/sharky_j.jpg",
#     photo_url: "http://naserca.com/images/shark.jpg",
#     humanized_time_ago: humanized_time_ago(15),
#     like_count: 0,
#     comment_count: 1,
#     comments: [{
#       username: "sharky_j",
#       text: "Out for the long weekend... too embarrassed to show y'all the beach bod!"
#     },
#     {
#       username: "sharky_b",
#       text: "Out for the long weekend... too embarrassed to show y'all the beach bod!"
#     }]
#   }

#   @finstagram_post_whale = {
#     username: "kirk_whalum",
#     avatar_url: "http://naserca.com/images/kirk_whalum.jpg",
#     photo_url: "http://naserca.com/images/whale.jpg",
#     humanized_time_ago: humanized_time_ago(65),
#     like_count: 0,
#     comment_count: 1,
#     comments: [{
#       username: "kirk_whalum",
#       text: "#weekendvibes"
#     }]
#   }

#   @finstagram_post_marlin = {
#     username: "marlin_peppa",
#     avatar_url: "http://naserca.com/images/marlin_peppa.jpg",
#     photo_url: "http://naserca.com/images/marlin.jpg",
#     humanized_time_ago: humanized_time_ago(190),
#     like_count: 0,
#     comment_count: 1,
#     comments: [{
#       username: "marlin_peppa",
#       text: "lunchtime! ;)"
#     }]
#   }

#   # [@finstagram_post_shark, @finstagram_post_whale, @finstagram_post_marlin].to_s

#   @finstagram_posts = [@finstagram_post_shark, @finstagram_post_whale, @finstagram_post_marlin]

#   erb(:index)
# end

get '/' do
  @finstagram_posts = FinstagramPost.order(created_at: :desc)
  #@current_user = User.find_by(id: session[:user_id])
  erb(:index)
end

post '/signup' do
  # params.to_s
  # grab user input values from params
  email =      params[:email]
  avatar_url = params[:avatar_url]
  username =   params[:username]
  password =   params[:password]
  
  # if email.present? && avatar_url.present? && username.present? && password.present?

  # instantiate and save a User
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
  
  # if user validations pass and user is saved
  if @user.save
    redirect to('/login')
    #"User #{username} saved!"
    # return readable representation of User object
    # escape_html user.inspect

  else
    erb(:signup)
    # display simple error message
    # escape_html user.errors.full_messages
  end
end

get '/signup' do  # if a user navigates to the path "/signup",
  @user = User.new # setup empty @user object
  erb(:signup) # render "app/views/signup.erb"
end


get '/login' do
  #@user = User.new
  erb(:login)
end

post '/login' do
  username = params[:username]
  password = params[:password]

  @user = User.find_by(username: username)
  
  if @user && @user.password == password
    session[:user_id] = @user.id
    redirect to('/')
    #"Success! User with id #{session[:user_id]} is logged in!"
  else
    @error_message = "Login failed."
    erb(:login)
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect to('/')
  #"Logout successfull!"
end

get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:"finstagram_posts/new")
end

post '/finstagram_posts' do
  photo_url = params[:photo_url]

  @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

  if @finstagram_post.save
    redirect(to('/'))
  else
    erb(:"finstagram_posts/new")
    #@finstagram_post.errors.full_messages.inspect
  end
end
#params.to_s

get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find(params[:id])   # find the finstagram post with the ID from the URL
  #escape_html @finstagram_post.inspect        # print to the screen for now
  erb(:"finstagram_posts/show") # render app/views/finstagram_posts/show.erb
end

post '/comments' do
  #params.to_s

  # point values from params to variables

  text = params[:text]
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a comment with those values & assign the comment to the 'current_user'
  comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the comment
  comment.save

  # 'redirect' back to wherever we came from 
  redirect(back)
end

post '/likes' do
  finstagram_post_id = params[:finstagram_post_id]

  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
  like.save

  redirect(back)
end

delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

