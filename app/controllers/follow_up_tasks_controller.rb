class FollowUpTasksController < DashboardController
  def index
    # 1. Start with the base query of incomplete tasks for the current user.
    base_query = current_user.follow_up_tasks.where(completed_at: nil)

    # 2. Initialize the Ransack search object with the search parameters from the URL.
    #    The `params[:q]` will come from the search form.
    @q = base_query.ransack(params[:q])

    # 3. Get the search results, eager load for performance, and set the default sort order.
    #    `@q.result` is the core of Ransack.
    @follow_up_tasks = @q.result
                         .includes(invitation: [:contact, :event])
                         .order(due_at: :asc)

    # 4. (Optional but recommended) Prepare the collection for the "Filter by Event" dropdown.
    #    We only want to show events that actually have pending tasks.
    @filterable_events = Event.where(id: base_query.joins(:invitation).select("invitations.event_id"))
                            .distinct
                            .order(:name)
  end
end