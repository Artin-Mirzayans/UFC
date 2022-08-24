class Fight < ApplicationRecord
  belongs_to :event
  belongs_to :red, class_name: "Fighter"
  belongs_to :blue, class_name: "Fighter"

  has_many :methodpredictions, dependent: :destroy
  has_many :distancepredictions, dependent: :destroy
  has_one :odd, dependent: :destroy
  has_one :result

  acts_as_list scope: [:placement]
  validates :red, presence: true
  validates :blue, presence: true
  validates :placement, presence: true

  enum placement: %i[MAIN PRELIMS EARLY]

  def get_method_prediction(user, corner)
    # Need an index for the column user_id on the predictions table so this query doesn't take forever
    self
      .methodpredictions
      .where(user: user, fighter: corner)
      .first_or_initialize
  end

  def get_distance_prediction(user, fight)
    # Need an index for the column user_id on the predictions table so this query doesn't take forever
    self.distancepredictions.where(user: user, fight: fight).first_or_initialize
  end

  def get_result(user, fight)
    self.result || self.build_result
  end
end
