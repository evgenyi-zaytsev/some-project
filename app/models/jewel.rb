class Jewel < ActiveRecord::Base
  acts_as_commentable
  has_paper_trail
  
  belongs_to :user
end
