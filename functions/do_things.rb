def login()
        db = SQLite3::Database.new("db/forum.db")
        db.results_as_hash = true
        
        finish = db.execute("SELECT id, password FROM users WHERE username=?",  params["Username"])
        session["Username"] = params["Username"]
        
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
    db = SQLite3::Database.new("db/forum.db")
    db.results_as_hash = true
    
    finish = db.execute("SELECT id FROM users WHERE username=?",  [params["Username"]])
    
    if finish.length > 0
        false
    end
    
    new_password = BCrypt::Password.create(params["Password"])
    
    db.execute("INSERT INTO users (username, password, email) VALUES (?, ?, ?)", [params["Username"], new_password, params["email"]])
    
    new_user_id = db.execute("SELECT id FROM Users WHERE username=?", [params["Username"]])
    
    return new_user_id[0]["id"]
end

def comments (params,userId)
        text = params["content"]
        db = SQLite3::Database.new 'db/forum.db'
        username = db.execute("SELECT username FROM Users WHERE id=?", [session["user"]])
     
    
        new_file_name = SecureRandom.uuid
        temp_file = params["image"]["tempfile"]
        path = File.path(temp_file)
    
        new_file = FileUtils.copy(path, "./public/img/#{new_file_name}") 
    
        db.execute("INSERT INTO posts (title, text, tag, author, authorId) VALUES(?,?,?,?,?)",[params['content'],session['user'],username,new_file_name])
