class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,        dependent: :destroy
  has_many :book_comment, dependent: :destroy
  has_many :favorites,    dependent: :destroy
  has_many :messages,     dependent: :destroy
  has_many :entries,      dependent: :destroy
  has_one_attached :profile_image


  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # ↑ フォローしている人の取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # ↑ フォローされている人の取得
  has_many :following_user, through: :follower, source: :followed
  # ↑ 自分がフォローしてる人
  has_many :followers_user, through: :followed, source: :follower
  # ↑ 自分をフォローしている人

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  #ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  #ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  #フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end



  #検索方法の分岐
  def self.search_for(word, method)
    if method == 'perfect'
      User.where(name: word)
    elsif method == 'forward'
      User.where('name LIKE ?', word + '%')
    elsif method == 'backward'
      User.where('name LIKE ?','%' + word)
    else
      User.where('name LIKE ?','%' + word + '%')
    end
  end



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
