class Post < ApplicationRecord
	has_many :teams, dependent: :destroy
end
