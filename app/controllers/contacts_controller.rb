class ContactsController < DashboardController
  before_action :set_contact, only: %i[ show edit update destroy ]

  # GET /contacts
  def index
    records = current_user.contacts.order(created_at: :desc)
    @search = records.ransack(params[:q])
    @pagy, @contacts = pagy(@search.result)
  end

  # GET /contacts/1
  def show
  end

  # GET /contacts/new
  def new
    @contact = current_user.contacts.build
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  def create
    @contact = current_user.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        flash.now[:notice] = "Contact was successfully submitted."
        # Implicitly renders create.turbo_stream.erb
        format.turbo_stream
      else
        flash.now[:alert] = @contact.errors.full_messages.to_sentence
        # Also implicitly renders create.turbo_stream.erb, but with an error status
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        flash.now[:notice] = "Contact was successfully updated."
        # Implicitly renders update.turbo_stream.erb
        format.turbo_stream
      else
        flash.now[:alert] = @contact.errors.full_messages.to_sentence
        # Also implicitly renders update.turbo_stream.erb, but with an error status
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy!
    flash.now[:notice] = "Contact was successfully destroyed."

    respond_to do |format|
      # Implicitly renders destroy.turbo_stream.erb
      format.turbo_stream
      format.html { redirect_to contacts_url, status: :see_other, notice: "Contact was successfully destroyed." }
    end
  end

  private

    def set_contact
      @contact = current_user.contacts.find(params[:id])
    end

    def contact_params
      params.expect(contact: [ :owner_id, :owner_type, :first_name, :last_name, :email, :phone_number, :how_we_met ])
    end
end