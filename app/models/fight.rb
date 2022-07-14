class Fight < ApplicationRecord
  belongs_to :event
    validates :f1, presence: true
    validates :f2, presence: true
  end