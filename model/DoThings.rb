module DoThings    
    # Allows user to log in 
    #
    # @param [String] username, user unique username
    # @param [String] password, user unique password
    #
    # @return [false], if credentials do not match do not match a user
    # @return [Integer], the first ID of finish
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

    # Allows user to create a new account 
    #
    # @param [String] username, user unique username
    # @param [String] password, user unique password
    #
    # @return [false], if credentials do not match do not match a user
    # @return [Integer], the ID of the user 
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

    # Allows user to create comments that displays who made it (NOT IN USE)
    #
    # @param [String] userId, user current ID
    # @param [Hash] params, hash including details for comments 
    # @option params [Image] image, picture generated from users computer
    # @option params [String] content, what user types in textfield
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

    # Allows user to create post with tags 
    #
    # @params [Hash] session, session hash used for user_id
    # @option session [String] user_id, user id.
    # @params [Hash] params, hash including details for posts
    # @option params [String] content, what user puts in textfield
    # @option params [String] tags, nametag that helps categorize specific posts
    # @option params [Image] image, picture generated from users computer
    def make_post(params, session)
        db = SQLite3::Database.new 'db/forum.db'
        db.results_as_hash = true
        
        # VARIABLES
        text = params["content"]
        username = db.execute("SELECT username FROM Users WHERE id=?", [session["user_id"]])[0]['username']
        tags = params["tags"].split(",").map{ |tag| db.execute("SELECT id FROM tags WHERE name=?", tag.strip() ) }

        # FILES
        new_file_name = SecureRandom.uuid
        temp_file = params["image"]["tempfile"]
        path = File.path(temp_file)
        new_file = FileUtils.copy(path, "./public/img/#{new_file_name}") 

        db.execute("INSERT INTO Posts (content, picture, userId,author) VALUES(?,?,?,?)",[params['content'], new_file_name, session['user_id'],username])
        post_id = db.execute("SELECT last_insert_rowid()") 
    
        tags.each do |tag_id|
            db.execute("INSERT INTO posts_tags (post_id, tag_id) VALUES (?,?)", [post_id[0][0], tag_id[0]["id"]])
        end
    end
    # Delets post with specified ID
    #
    # @params [Integer] id, user unique ID 
    def delete_post_by_id(id)
        db = SQLite3::Database.new 'db/forum.db'
        db.results_as_hash = true

        db.execute('DELETE FROM posts WHERE id=?', id)
    end
end