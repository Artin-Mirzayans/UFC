class Fight < ApplicationRecord
    validates :f1, presence: true
    validates :f2, presence: true
  end