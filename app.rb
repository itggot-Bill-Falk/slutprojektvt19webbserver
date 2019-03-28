require 'sinatra'
require 'slim'
require 'bcrypt'
require 'sqlite3'

enable :sessions

require_relative 'models/do_things.rb'
require_relative 'models/get_things.rb'

get('/') do
    posts = get_all_posts()

    slim(:index, locals:{posts: posts})
end

get('/login') do
    slim(:login)
end

post('/login') do
    user = login(params)
    if user
        session['user_id'] = user
        redirect('/')
    else
        redirect('/login')
    end
end

get('/register') do
    slim(:register)
end

post('/register') do
    user = register(params)
    if user
        session['user_id'] = user
        redirect('/')
    else
        redirect('/register')
    end
end

get('/user/:id') do
    posts = get_posts_by_user(params['id'])

    slim(:user, locals:{posts: posts})
end

get('/forum/:tag') do
    posts = get_posts_by_tag(params['tag'])
    
    slim(:forum, locals:{posts: posts})
end

get('/post/:id') do
    post = get_post_by_id(params['id'])
    comments = get_comments_by_post(params['id'])

    slim(:post, locals:{post: post, comments: comments})
end

post('/comment/:post_id') do
    comment(params, session['user_id'])

    redirect(back)
end