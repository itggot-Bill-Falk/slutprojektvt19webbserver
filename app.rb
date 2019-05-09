require 'sinatra'
require 'slim'
require 'bcrypt'
require 'sqlite3'
require 'JSON'

enable :sessions

require_relative 'functions/DoThings'
require_relative 'functions/GetThings'

# Display landing page
#
get('/') do
    posts = get_all_posts()

    slim(:index, locals:{posts: posts, session: session})
end


# Display login form
#
get('/login') do
    slim(:login)
end

# Checks if account exists and logs into account
#
# @params [string] Username, The username
# @param [string] Password, The password
#
# @See DoThings#Login
post('/login') do
    user = login(params)
    if user
        session['user_id'] = user
        redirect('/')
    else
        redirect('/login')
    end
end

# Display register form
#
get('/register') do
    slim(:register)
end

# Attemps to register user and logs in if successfull
#
# @params [string] Username, The username
# @params [string] Password, The password
#
# @See DoThings#Register
post('/register') do
    user = register(params)
    if user
        session['user_id'] = user
        redirect('/')
    else
        redirect('/register')
    end
end

# Get all posts based on the user_id
#
# @params [integer] id, User uniqe id
#
# @See GetThings#GetPostByUser
get('/user/:id') do
    posts = get_posts_by_user(params['id'])

    slim(:user, locals:{posts: posts})
end

# Displays all topics with specified tag
#
# @param [string] tags, Specified tag name
#
# @See DoThings#GetPostsByTag
get('/forum/:tag') do
    posts = get_posts_by_tag(params['tag'])
    
    slim(:forum, locals:{posts: posts})
end

# Gets everything from posts based on id 
#
#  @params [integer] id, User uniqe id
#
# @See GetThings#GetPostById
get('/post/:id') do
    post = get_post_by_id(params['id'])
    comments = get_comments_by_post(params['id'])

    slim(:post, locals:{post: post, comments: comments})
end

# Allows user to comment if they are logged in 
#
# @params [string] content, User message
# @param [string] image, User picture
#
# @See DoThings#Comment
post('/comment/:post_id') do
    comment(params, session['user_id'])

    redirect(back)
end

# Destroys the current session and redirects to landing page
#
post('/logout') do
    session.destroy
    redirect('/')
end

# Gets all tags from database
#
get('/tags') do
    result = get_all_tags()

    slim(:tags_list, locals:{tags: result})
end

# Gets everything from post_tags bad on tag_id
#
# @params [integer] id, User unique id
#
# @See GetThings#GetPostByTag
get('/tags/:id') do
    result = get_posts_by_tag(params['id'])
    puts JSON.pretty_generate({posts: result})
    slim(:tags, locals:{posts: result})
end

# Add new posts if user is logged in and redirects to profile page
#
# @params [string] content, User message
# @params [string] image, User picture
# @params [string] tags, specified post categories
#
# @See DoThings#MakePost
post('/post') do
     make_post(params, session)
    redirect(back)
end

#
#
post('/delete/:id') do
    delete_post_by_id(params['id'].to_i)
    redirect(back)
end