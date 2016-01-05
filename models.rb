class User < ActiveRecord::Base
	# dependent: :destroy from bradley - will delete posts associated with a user upon deletion of user
	has_many :posts, dependent: :destroy
end

class Post < ActiveRecord::Base
	belongs_to :user
end