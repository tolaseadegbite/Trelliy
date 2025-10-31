class DashboardController < ApplicationController
  layout "dashboard"

  def show
    # --- Section 1: Pending Follow-Ups ---
    # Fetch all tasks assigned to the current user that are not yet completed.
    # We eager load the entire chain (invitation -> event and contact) to
    # prevent N+1 database queries in the view.
    @pending_follow_ups = current_user.follow_up_tasks
                                    .where(completed_at: nil)
                                    .order(due_at: :asc)
                                    .includes(invitation: [:event, :contact])
                                    .limit(15)

    # --- Section 2: Upcoming Events ---
    # Fetch the next 5 events scheduled for the future.
    @upcoming_events = current_user.events
                                 .where("starts_at > ?", Time.current)
                                 .order(starts_at: :asc)
                                 .limit(15)
  end
end