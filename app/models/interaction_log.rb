class InteractionLog < ApplicationRecord
  belongs_to :contact
  belongs_to :user
  belongs_to :follow_up_task
end
