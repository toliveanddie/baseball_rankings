class Post < ApplicationRecord
	has_many :teams, dependent: :destroy
	has_many :players, dependent: :destroy
	has_many :pitchers, dependent: :destroy
	has_many :leaders, dependent: :destroy
	has_many :pleaders, dependent: :destroy

end
