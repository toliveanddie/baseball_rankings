class Post < ApplicationRecord
	has_many :teams, dependent: :destroy
	has_many :players, dependent: :destroy
	has_many :pitchers, dependent: :destroy
end
