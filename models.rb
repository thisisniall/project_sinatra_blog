class User < ActiveRecord::Base
	has_many :Posts
end

class Post < ActiveRecord::Base
	belongs_to :User
end