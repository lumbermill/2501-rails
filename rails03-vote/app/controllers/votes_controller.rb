class VotesController < ApplicationController
  before_action :set_vote, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[ new create show ]

  # GET /votes or /votes.json
  def index
    @votes = Vote.all
  end

  # GET /votes/1 or /votes/1.json
  def show
  end

  # GET /votes/new
  def new
    @vote = Vote.new
  end

  # GET /votes/1/edit
  def edit
  end

  # POST /votes or /votes.json
  def create
    @vote = Vote.new(vote_params)
    @vote.update_answers(params)
    respond_to do |format|
      if @vote.save
        format.html { redirect_to event_path(@vote.event, token: @vote.event.token), notice: "予定を登録しました！" }
        format.json { render :show, status: :created, location: @vote }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /votes/1 or /votes/1.json
  def update
    respond_to do |format|
      if @vote.update(vote_params)
        format.html { redirect_to @vote, notice: "Vote was successfully updated." }
        format.json { render :show, status: :ok, location: @vote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1 or /votes/1.json
  def destroy
    @vote.destroy!

    respond_to do |format|
      format.html { redirect_to votes_path, status: :see_other, notice: "Vote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def vote_params
      params.expect(vote: [ :event_id, :name, :comment ]) # answers will be set in Vote.update_answers
    end
end
