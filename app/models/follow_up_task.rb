class FollowUpTask < ApplicationRecord
  belongs_to :invitation
  belongs_to :user
end
