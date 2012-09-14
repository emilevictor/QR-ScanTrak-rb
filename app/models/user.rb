class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :tags
  belongs_to :team

  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :admin, :password_confirmation,
   :remember_me, :first_name, :last_name, :team_id
  # attr_accessible :title, :body
end
