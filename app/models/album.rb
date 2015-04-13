class Album < ActiveRecord::Base
	has_many :photos, dependent: :destroy
	validates_presence_of :title
end
