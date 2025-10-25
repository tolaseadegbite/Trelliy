class Event < ApplicationRecord
  belongs_to :owner, polymorphic: true

  validates :name, presence: true
  validates :starts_at, presence: true
  validates :duration_in_minutes, presence: true, numericality: { greater_than: 0 }

  # This is a "virtual attribute". It feels like a database column, but it's calculated.
  def ends_at
    # The `.minutes` is a helpful Rails duration helper
    starts_at + duration_in_minutes.minutes
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ name starts_at duration_in_minutes owner ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
