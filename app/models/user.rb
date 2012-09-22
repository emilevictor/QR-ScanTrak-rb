class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :tags, :through => :games
  belongs_to :team, :inverse_of => :users
  has_many :scans, :through => :games

  has_many :created_teams, :class_name => "Team"

  has_and_belongs_to_many :games

  

  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :admin, :password_confirmation,
   :remember_me, :first_name, :last_name, :team, :comments, :default_game_id
  # attr_accessible :title, :body


  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}")
    else
      scoped
    end

  end

  def currentGame()

    begin
      @game = games.find(default_game_id)
    rescue Exception => exc
      if games.first.nil?
        flash[:alert] = "You're not in a game."
        redirect_to games_joinAGame_path
      end
      default_game_id = games.first.id
      return game.first     
    end
    

    if @game.nil?
      default_game_id = games.first.id
      return game.first
    else
      return @game
    end
  end
end
