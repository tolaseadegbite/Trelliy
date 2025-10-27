class EventsController < DashboardController
  before_action :set_event, only: %i[ show edit update destroy ]

  def index
    @date = Date.parse(params.fetch(:date, Date.today.to_s))
    events_for_month = current_user.events.where(starts_at: @date.all_month)
    @events_by_date = events_for_month.group_by { |event| event.starts_at.to_date }

    records = current_user.events.order(starts_at: :asc)
    @search = records.ransack(params[:q])
    @pagy, @list_events = pagy(@search.result)
  end

  def show
    @invitations = @event.invitations.includes(:contact).order("contacts.first_name ASC")

    @new_invitation = @event.invitations.build
  end

  def new
    @event = current_user.events.build
  end

  def edit
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      flash.now[:notice] = "Event was successfully submitted."
      prepare_calendar_data
      render :create
    else
      flash.now[:alert] = @event.errors.full_messages.to_sentence
      render :create, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      flash.now[:notice] = "Event was successfully updated."
      prepare_calendar_data
      render :update
    else
      flash.now[:alert] = @event.errors.full_messages.to_sentence
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!
    flash.now[:notice] = "Event was successfully destroyed."
    prepare_calendar_data
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
    end
  end

  private

    def set_event
      @event = current_user.events.find(params[:id])
    end

    def event_params
      params.expect(event: [ :owner_id, :owner_type, :name, :starts_at, :duration_in_minutes, contact_ids: [] ])
    end

    def prepare_calendar_data
    # Use the date of the event that was just changed, or fall back to params/today
    # This ensures the calendar re-renders for the correct month.
    @date = @event&.starts_at&.to_date || Date.parse(params.fetch(:date, Date.today.to_s))
    
    events_for_month = current_user.events.where(starts_at: @date.all_month)
    @events_by_date = events_for_month.group_by { |event| event.starts_at.to_date }
  end

  def prepare_list_data
    records = current_user.events.order(starts_at: :asc)
    @search = records.ransack(params[:q])
    @pagy, @list_events = pagy(@search.result)
  end
end