class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates :name, :presence => true

  has_many :posts, :dependent => :destroy
  has_many :authentications, :dependent => :destroy

  before_save :ensure_authentication_token
  
  def apply_omniauth(omniauth) 
    self.email = omniauth['info']['email'] if email.blank?
    self.name = omniauth['info']['name'] if name.blank?
    
    self.confirmed_at = Time.now if confirmed_at.nil? and email == omniauth['info']['email'] 
 
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :information => omniauth)
  
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def facebook_token 
    @facebook = authentications.find_by_provider('facebook').try(:[], :token)
  end

  def facebook 
    @facebook ||= Koala::Facebook::API.new(facebook_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    nil
  end

  def upcoming_birthdays(til = 1.week.from_now)
    Rails.cache.fetch("upcoming_birthdays_#{id}", :expires_in => 12.hours ) do
      query = "SELECT uid, name, birthday_date, pic_small 
               FROM user 
               WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) 
               AND strlen(birthday_date) != 0 
               AND (
                (
                  substr(birthday_date, 0, 2) = '#{Time.now.month}' 
                  AND
                  substr(birthday_date, 3, 5) IN (#{(Time.now.day..31).to_a.to_s.tr("[]", "")})
                ) #{ Time.now.month == til.month ? "AND" : "OR" } (
                  substr(birthday_date, 0, 2) = '#{til.month}' 
                  AND
                  substr(birthday_date, 3, 5) IN (#{(1..til.day).to_a.to_s.tr("[]", "")})
                )
              ) 
              ORDER BY birthday_date"
=begin
      query = "SELECT uid, name, birthday_date, pic_small
               FROM user 
               WHERE uid IN (100001943632811, 1388897928)"
=end

      friends = facebook { |fb| fb.fql_query(query) }
    end
  end

  def photos_together(friends)
    Rails.cache.fetch("photos_together_#{id}", :expires_in => 12.hours) do
      queries = {}
      friends.each do |friend|
        queries[friend['uid']] = "SELECT pid, src_small, src_big, created, like_info FROM photo WHERE
                                    pid IN (SELECT pid FROM photo_tag WHERE subject=#{friend['uid']})
                                  AND
                                    pid IN (SELECT pid FROM photo_tag WHERE subject=me())
                                  ORDER BY like_info DESC LIMIT 4"
      end
      photos = facebook { |fb| fb.fql_multiquery(queries) }
    end
  end


end
