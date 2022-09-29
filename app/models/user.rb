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
  validates_format_of :username, :with => /\A[-a-z]+\Z/

  enum role: %i[user moderator admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
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
