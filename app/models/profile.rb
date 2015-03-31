class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :educations
  has_many :employments
end
