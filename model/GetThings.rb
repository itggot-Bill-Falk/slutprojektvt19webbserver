module GetThings

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

    # Aquires all posts and then returns them
    #
    def get_all_posts()
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true

        posts = db.execute('SELECT * FROM posts')
        
        return posts
    end
    # Aquires all tags then returns them
    #
    def get_all_tags()
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true

        tags = db.execute('SELECT * FROM tags')
        
        return tags
    end
    # Aquires post based on id
    #
    # @param [Integer] id, user unique id
    #
    # @return [Hash]
    #   * :id [integer], post specific id
    #   * :content[String], user generated text
    #   * :picture[String], user generated image
    #   * :userid [Integer], user unique id
    #   * :author [String], creator of the post
    def get_post_by_id(id)
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true

        post = db.execute('SELECT * FROM posts WHERE id=?', [id])[0]
        
        return post
    end

    # Aquires post based on user 
    #
    # @param [Integer] user_id, user unique id
    #
    # @return [Array]
    #   * :id [integer], post specific id
    #   * :content[String], user generated text
    #   * :picture[String], user generated image
    #   * :userid [Integer], user unique id
    #   * :author [String], creator of the post
    def get_posts_by_user(user_id)
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true

        posts = db.execute('SELECT * FROM posts WHERE userid=?', [user_id])
        
        return posts
    end
    # Aquires post based on tag
    #
    # @param [String] tag, tool used to categorize posts tagName
    #
    # @return [Array]
    #   * :id [integer], post specific id
    #   * :content[String], user generated text
    #   * :picture[String], user generated image
    #   * :userid [Integer], user unique id
    #   * :author [String], creator of the post
    def get_posts_by_tag(tag)
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true
        
        posts = db.execute('SELECT * FROM posts_tags WHERE tag_id=?', [tag]).map{ |post| db.execute("SELECT * FROM posts WHERE id=?",[post["post_id"]]) }.compact()
        posts = posts.delete_if { |post| post.flatten.empty? }
        return posts
    end
    # Aquires user based on their user_id
    #
    # @param [Integer] post_id, id given to post when posted
    #
    # @return [Array]
    #   * :userid [Integer], user unique id
    def get_users_by_post_id(post_id)
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true
        
        posts = db.execute('SELECT userid FROM posts WHERE id=?', [post_id]) 
        return posts
    end
     # Aquires username from user
    #
    # @param [Integer] userId, user unique id
    #
    # @return [Array]
    #   * :author [String], creator of the post
    def get_username_by_user(userid)
        db = SQLite3::Database.open('db/Forum.db')
        db.results_as_hash = true
        
        posts = db.execute('SELECT username FROM users WHERE id=?', [userid]) 
        return posts
    end   
 
end



