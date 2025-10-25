class EventsController < DashboardController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events
  def index
    @date = Date.parse(params.fetch(:date, Date.today.to_s))
    events_for_month = current_user.events.where(starts_at: @date.all_month)
    @events_by_date = events_for_month.group_by { |event| event.starts_at.to_date }

    records = current_user.events.order(starts_at: :asc)
    @search = records.ransack(params[:q])
    @pagy, @list_events = pagy(@search.result)
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = current_user.events.new(event_params)

    respond_to do |format|
      if @event.save
        flash.now[:notice] = "Event was successfully submitted."
        # Implicitly renders create.turbo_stream.erb
        format.turbo_stream
      else
        flash.now[:alert] = @event.errors.full_messages.to_sentence
        # Also implicitly renders create.turbo_stream.erb, but with an error status
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  def update
    respond_to do |format|
      if @event.update(event_params)
        flash.now[:notice] = "Event was successfully updated."
        # Implicitly renders update.turbo_stream.erb
        format.turbo_stream
      else
        flash.now[:alert] = @event.errors.full_messages.to_sentence
        # Also implicitly renders update.turbo_stream.erb, but with an error status
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy!
    flash.now[:notice] = "Event was successfully destroyed."

    respond_to do |format|
      # Implicitly renders destroy.turbo_stream.erb
      format.turbo_stream
      format.html { redirect_to events_url, status: :see_other, notice: "Event was successfully destroyed." }
    end
  end

  private

    def set_event
      @event = current_user.events.find(params[:id])
    end

    def event_params
      params.expect(event: [ :owner_id, :owner_type, :name, :starts_at, :duration_in_minutes ])
    end
end