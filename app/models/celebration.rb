class Celebration < ActiveRecord::Base
  attr_accessible :celebrated_on, :country, :message, :name

  validates :name, :presence => true
  validates :country, :presence => true
  validates :message, :presence => true
  validate  :future_date

  def future_date
  	if celebrated_on.past?
  	errors.add(:celebrated_on, "Can't be in the past") 
  	end
  end

  def self.upcoming(til = 1.week.from_now)
  	where("celebrated_on >= ? AND celebrated_on <= ?", Time.now, til).order("celebrated_on ASC")
  end
end
