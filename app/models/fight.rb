class Fight < ApplicationRecord
  belongs_to :event
  belongs_to :red, class_name: "Fighter"
  belongs_to :blue, class_name: "Fighter"
  acts_as_list scope: :event
    # validates :red, presence: true
    # validates :blue, presence: true 
    # validates :placement, presence: true

    enum placement: [:MAINCARD, :PRELIMS, :EARLYPRELIMS]

  end