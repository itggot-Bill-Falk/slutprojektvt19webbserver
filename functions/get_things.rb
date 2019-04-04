def get_all_users()
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true

    users = db.execute('SELECT * FROM users')
    
    return users
end

def get_user_by_id(id)
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true
    
    user = db.execute('SELECT * FROM users WHERE id=?', [id])[0]
    
    return user
end

def get_all_posts()
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true

    posts = db.execute('SELECT * FROM posts')
    
    return posts
end

def get_post_by_id(id)
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true

    post = db.execute('SELECT * FROM posts WHERE id=?', [id])[0]
    
    return post
end

def get_posts_by_user(user_id)
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true

    posts = db.execute('SELECT * FROM posts WHERE userId=?', [user_id])
    
    return posts
end

def get_posts_by_tag(tag)
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true

    posts = db.execute('SELECT * FROM posts WHERE tag=?', [tag])
    
    return posts
end

def get_comments_by_post(post_id)
    db = SQLite3::Database.open('db/Forum.db')
    db.results_as_hash = true

    comments = db.execute('SELECT comments.text, users.username FROM comments INNER JOIN users ON comments.userId=users.id WHERE comments.postId=?', [post_id])
    p comments
    return comments
end