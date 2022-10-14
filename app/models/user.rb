class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :methodpredictions
  has_many :distancepredictions
  has_many :user_event_budgets

  validates_uniqueness_of :username
  validates_presence_of :username
  validates :username, length: { in: 4..16 }
  validate :username_format

  enum role: %i[user moderator admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def username_format 
    regexp = /^[a-zA-Z0-9]*$/
    if !self.username.match(regexp)
      errors.add(:base, "Username may only contain letters and numbers")
    end
  end

  def email_required?
    false
  end
  
  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
