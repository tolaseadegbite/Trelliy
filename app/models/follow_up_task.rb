class FollowUpTask < ApplicationRecord
  belongs_to :invitation
  belongs_to :user

  has_many :interaction_logs, dependent: :destroy
end
