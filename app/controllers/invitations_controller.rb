class InvitationsController < ApplicationController
  before_action :set_event, only: [:create]
  before_action :set_invitation, only: [:update]

  # POST /events/:event_id/invitations
  def create
    @invitation = @event.invitations.build(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.turbo_stream
        format.html { redirect_to @event, notice: 'Invitation was successfully created.' }
      else
        # If creation fails, re-render the form with errors.
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_invitation_form", partial: "invitations/form", locals: { event: @event, invitation: @invitation }) }
        format.html { redirect_to @event, alert: 'Failed to create invitation.' }
      end
    end
  end

  # PATCH/PUT /invitations/:id
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        create_follow_up_task_if_needed(@invitation)
        # On success, just respond with Turbo Stream. The view will handle the update.
        format.turbo_stream
        format.html { redirect_to @invitation.event, notice: 'Invitation was successfully updated.' }
      else
        # If update fails, re-render the partial with error messages.
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@invitation, partial: "invitations/invitation", locals: { invitation: @invitation }) }
        format.html { redirect_to @invitation.event, alert: 'Failed to update invitation.' }
      end
    end
  end

  private

  def set_event
    # Assuming events are owned by the current user in the MVP
    @event = current_user.events.find(params[:event_id])
  end

  def set_invitation
    # Ensure a user can only update invitations for events they own.
    @invitation = Invitation.joins(:event).where(events: { owner: current_user }).find(params[:id])
  end

  def invitation_params
    params.require(:invitation).permit(:contact_id, :status, :notes)
  end

  # This is the core business logic of the application.
  def create_follow_up_task_if_needed(invitation)
    return unless invitation.attended? && invitation.saved_change_to_status?

    # Prevent creating a duplicate task if one somehow already exists.
    return if FollowUpTask.exists?(invitation_id: invitation.id)

    # Calculate when the reminder is due.
    # For MVP, we can hardcode this. Later, this would read from user settings.
    event_end_time = invitation.event.starts_at + invitation.event.duration_in_minutes.minutes
    due_date = event_end_time.tomorrow.beginning_of_day + 9.hours # Next day at 9 AM

    FollowUpTask.create!(
      invitation: invitation,
      user: current_user,
      due_at: due_date
    )
  end
end