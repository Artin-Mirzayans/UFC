class Fight < ApplicationRecord
  belongs_to :event
  acts_as_list scope: :event
    validates :f1, presence: true
    validates :f2, presence: true
    validates :placement, presence: true

    enum placement: [:MainCard, :Prelims, :EarlyPrelims]
  end