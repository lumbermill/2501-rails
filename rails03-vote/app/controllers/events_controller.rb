class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[ root new create show ]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
    unless authenticated?
      if params[:token] != @event.token
        redirect_to root_path(@event), notice: "イベントにアクセスするにはログインするかトークンが必要です。"
        return
      end
    end
    @votes = @event.votes.order(:id)
    @selected_rows = @event.indexes_of_top_schedules
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = Current.session&.user&.id || 1 # If user is not logged in, set to 1 (admin)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event,token:@event.token), notice: "イベントを新規作成しました。" }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "イベントを更新しました。" }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def root
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.expect(event: [ :title, :schedules, :user_id ])
    end
end
