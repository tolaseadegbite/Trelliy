class Invitation < ApplicationRecord
  belongs_to :contact
  belongs_to :event
  has_many :follow_up_tasks
  has_many :interaction_logs, through: :follow_up_tasks

  enum :status, {
    invited: 0,
    accepted: 1,
    declined: 2,
    attended: 3
  }

  validates :status, presence: true
  validates :contact_id, uniqueness: { scope: :event_id }

  def self.ransackable_attributes(auth_object = nil)
    [ "event_id" ]
  end
end
