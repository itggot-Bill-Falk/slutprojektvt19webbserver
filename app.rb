require 'sinatra'
require 'slim'
require 'bcrypt'
require 'sqlite3'
require 'JSON'

enable :sessions

require_relative 'model/DoThings'
require_relative 'model/GetThings'

include DoThings
include GetThings

before() do
    if session['user_id'] 
        @username = get_username_by_user(session['user_id']) [0]['username']
    else
        @username = ""
    end
end



# Display landing page
#
# @see Model#get_all_posts
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
# @param [String] Username, The username
# @param [String] Password, The password
#
# @see Model#login
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
# @param [String] Username, The username
# @param [String] Password, The password
#
# @see Model#register
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
# @param [Integer] id, User uniqe id
#
# @see Model#get_posts_by_user
get('/user/:id') do
    posts = get_posts_by_user(params['id'])

    slim(:user, locals:{posts: posts})
end

# Displays all topics with specified tag
#
# @param [String] tags, Specified tag name
#
# @see Model#get_posts_by_tag
get('/forum/:tag') do
    posts = get_posts_by_tag(params['tag'])
    
    slim(:forum, locals:{posts: posts})
end

# Gets everything from posts based on id 
#
# @param [Integer] id, User uniqe id
#
# @see Model#get_post_by_id
# @see Model#get_comments_by_post
get('/post/:id') do
    post = get_post_by_id(params['id'])
    comments = get_comments_by_post(params['id'])

    slim(:post, locals:{post: post, comments: comments})
end

# Allows user to comment if they are logged in 
#
# @param [String] content, User message
# @param [String] image, User picture
#
# @see Model#comment
post('/comment/:post_id') do
    if session['user_id']
        comment(params, session['user_id'])
    end
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
# @see Model#get_all_tags
get('/tags') do
    result = get_all_tags()

    slim(:tags_list, locals:{tags: result})
end

# Gets everything from post_tags based on tag_id
#
# @param [Integer] id, User unique id
#
# @see Model#get_posts_by_tag
get('/tags/:id') do
    result = get_posts_by_tag(params['id'])
    puts JSON.pretty_generate({posts: result})
    slim(:tags, locals:{posts: result})
end

# Add new posts if user is logged in and redirects to profile page
#
# @param [String] content, User message
# @param [String] image, User picture
# @param [String] tags, specified post categories
#
# @see Model#make_post
post('/post') do
    if session['user_id']
        make_post(params, session)
    end
    redirect(back)
end

# Delets the post with specified id
#
# @param [Integer] id, User unique id
#
# @see Model#get_users_by_post_id
# @see Model#delete_post_by_id
post('/delete/:id') do
    if session['user_id'] == get_users_by_post_id(params['id'])[0]['userId']
        delete_post_by_id(params['id'].to_i)
    end
    redirect(back)
end