def login(params)
        db = SQLite3::Database.new("db/forum.db")
        db.results_as_hash = true
        
        finish = db.execute("SELECT id, password FROM users WHERE username=?",  params["Username"])
        
        if finish.length == 0 
            return false
        end
        
        if BCrypt::Password.new(finish[0]["password"]) == params["Password"]
            return finish[0]["id"]
        else
            return false
        end
    end

def register(params)
    db = SQLite3::Database.new("db/Forum.db")
    db.results_as_hash = true
    
    finish = db.execute("SELECT id FROM users WHERE username=?",  [params["Username"]])
    
    if finish.length > 0
        false
    end
    
    new_password = BCrypt::Password.create(params["Password"])
    
    db.execute("INSERT INTO users (username, password) VALUES (?, ?)", [params["Username"], new_password])
    
    new_user_id = db.execute("SELECT id FROM users WHERE username=?", [params["Username"]])
    
    return new_user_id[0]["id"]
end

def comments (params,userId)
        text = params["content"]
        db = SQLite3::Database.new 'db/Forum.db'
        username = db.execute("SELECT username FROM Users WHERE id=?", [session["user"]])
     
    
        new_file_name = SecureRandom.uuid
        temp_file = params["image"]["tempfile"]
        path = File.path(temp_file)
    
        new_file = FileUtils.copy(path, "./public/img/#{new_file_name}") 
    
        db.execute("INSERT INTO posts (title, text, tag, author, authorId) VALUES(?,?,?,?,?)",[params['content'],session['user'],username,new_file_name])
end

def make_post(params, session)
    db = SQLite3::Database.new 'db/forum.db'
    db.results_as_hash = true
    
    # VARIABLES
    text = params["content"]
    username = db.execute("SELECT username FROM Users WHERE id=?", [session["user_id"]])[0]['username']
    tag_id = db.execute("SELECT id FROM tags WHERE name=?", params['tag'])[0]['id']

    # FILES
    new_file_name = SecureRandom.uuid
    temp_file = params["image"]["tempfile"]
    path = File.path(temp_file)
    new_file = FileUtils.copy(path, "./public/img/#{new_file_name}") 

    db.execute("INSERT INTO Posts (content, picture, userId, tagId, author) VALUES(?,?,?,?,?)",[params['content'], new_file_name, session['user_id'], tag_id ,username])
end

def delete_post_by_id(id)
    db = SQLite3::Database.new 'db/forum.db'
    db.results_as_hash = true

    db.execute('DELETE FROM posts WHERE id=?', id)
end