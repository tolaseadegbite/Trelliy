class InvitationsController < ApplicationController
  before_action :set_event, only: [:create]
  before_action :set_invitation, only: [ :edit, :update, :destroy ]
  before_action :set_available_contacts, only: [ :create ]

  # POST /events/:event_id/invitations
  def create
    contact_ids = params.dig(:invitation, :contact_ids)&.reject(&:blank?)

    if contact_ids.present?
      @new_invitations = contact_ids.map do |contact_id|
        @event.invitations.create(contact_id: contact_id)
      end

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @event, notice: "#{contact_ids.count} invitations sent." }
      end
    else
      redirect_to @event, alert: "No contacts selected."
    end
  end

  # GET /invitations/:id/edit
  def edit
  end

  # PATCH/PUT /invitations/:id
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        create_follow_up_task_if_needed(@invitation)
        # On success, just respond with Turbo Stream. The view will handle the update.
        format.turbo_stream
        format.html { redirect_to @invitation.event, notice: "Invitation was successfully updated." }
      else
        # If update fails, re-render the partial with error messages.
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@invitation, partial: "invitations/invitation", locals: { invitation: @invitation }) }
        format.html { redirect_to @invitation.event, alert: "Failed to update invitation." }
      end
    end
  end

  # DELETE /invitations/:id
  def destroy
    @invitation.destroy!

    respond_to do |format|
      # This Turbo Stream will find the invitation's frame and remove it from the page.
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@invitation) }
      format.html { redirect_to @invitation.event, notice: 'Invitation was successfully removed.' }
    end
  end

  private

  def set_event
    @event = current_user.events.find(params[:event_id])
  end

  def set_invitation
    @invitation = Invitation.joins(:event).where(events: { owner: current_user }).find(params[:id])
    @event = @invitation.event
  end

  def set_available_contacts
    invited_ids = @event.invitations.pluck(:contact_id)
    @available_contacts = current_user.contacts.where.not(id: invited_ids).order(:first_name)
  end

  def invitation_params
    params.require(:invitation).permit(:contact_id, :status, :notes)
  end

  def create_follow_up_task_if_needed(invitation)
    return unless invitation.attended? && invitation.saved_change_to_status?

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
