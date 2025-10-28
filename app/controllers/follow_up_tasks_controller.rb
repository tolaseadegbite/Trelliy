class FollowUpTasksController < DashboardController
    def index
    @follow_up_tasks = current_user.follow_up_tasks
                                   .where(completed_at: nil)
                                   .includes(invitation: [:contact, :event]) # Critical performance optimization
                                   .order(due_at: :asc)
  end
end
