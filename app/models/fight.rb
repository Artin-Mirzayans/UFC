class Fight < ApplicationRecord
  belongs_to :event
  acts_as_list scope: :event
    validates :red, presence: true
    validates :blue, presence: true 
    validates :placement, presence: true

    enum placement: [:MAINCARD, :PRELIMS, :EARLYPRELIMS]

  end