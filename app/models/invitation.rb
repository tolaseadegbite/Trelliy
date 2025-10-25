class Invitation < ApplicationRecord
  belongs_to :contact
  belongs_to :event

  enum status: {
    invited: 0,
    accepted: 1,
    declined: 2,
    attended: 3
  }

  validates :status, presence: true
  validates :contact_id, uniqueness: { scope: :event_id }
end
