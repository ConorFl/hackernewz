enable :sessions
before do
  @posts = Post.all
end

get '/' do
  erb :index

end

get '/comments/:post_id' do
  @post = Post.find_by_id(params[:post_id])
  @comments = Comment.where('post_id = ?', params[:post_id])
  erb :post_comments
end

get '/post/:post_id' do
  @post = Post.find_by_id(params[:post_id])
  @comments = Comment.where('post_id = ?', params[:post_id])
  if @post.url != ""
    redirect "http://#{@post.url}"
  else
    erb :post_comments
  end
end

post '/comments/:post_id' do
  redirect '/register' if session[:current_user_id].nil?
  @comment = Comment.create(body: params[:comment_body])
  @comments = Comment.where('post_id = ?', params[:post_id])
  Post.find_by_id(params[:post_id]).comments << @comment
  User.find_by_id(session[:current_user_id]).comments << @comment
  erb :comments_partial, :layout => false
end

get '/register' do
  erb :register
end

get '/login' do
  erb :login
end

post '/register' do
  @user = User.create(:name=> params[:name], :email => params[:email], 
                      :password => params[:password], :password_confirmation=>params[:confirmpassword])
  if @user.valid?
    session[:current_user_id] = @user.id
    erb :index
  else
    @error = @user.errors.messages.first
    erb :register
  end
end

post '/login' do
  @email = params[:email]
  @password = params[:password]
  @user = User.find_by_email(@email)
  if @user && @user.authenticate(params[:password])
    
    session[:current_user_id] = @user.id
    erb :index
  else
    redirect '/login'
  end
end

get '/logout' do
  session.clear
  erb :index
end

get '/new_post' do
  erb :new_post
end  

post '/new_post' do
  @post = Post.create(:title=> params[:title], :body =>params[:body], :url => params[:url])
  User.find_by_id(session[:current_user_id]).posts << @post
  @posts = Post.all
  erb :index
end

get '/up_comments/:id' do
  redirect '/register' if session[:current_user_id].nil?
  @comment_votes = Comment.find(params[:id]).comment_votes
  @comment_vote = CommentVote.create(value: 1)
  Comment.find_by_id(params[:id]).comment_votes << @comment_vote
  User.find_by_id(session[:current_user_id]).comment_votes << @comment_vote
  @post = Comment.find(params[:id]).post
  @posts = Post.all
  redirect "/comments/#{@post.id}"
end

get '/up_posts/:id' do
  redirect '/register' if session[:current_user_id].nil?
  @post_vote = PostVote.create(value: 1)
  Post.find_by_id(params[:id]).post_votes << @post_vote
  User.find_by_id(session[:current_user_id]).post_votes << @post_vote
  redirect "/"
end
