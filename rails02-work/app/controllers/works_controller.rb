class WorksController < ApplicationController
  before_action :set_work, only: %i[ show edit update destroy ]

  # GET /works
  def index
    @works = Work.all
  end

  # GET /works/1
  def show
  end

  # GET /works/new
  def new
    @work = Work.new
    @work.user = Current.user if Current.user
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  def create
    @work = Work.new(work_params)

    if @work.save
      redirect_to @work, notice: "Work was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /works/1
  def update
    if @work.update(work_params)
      redirect_to @work, notice: "Work was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /works/1
  def destroy
    @work.destroy!
    redirect_to works_path, notice: "Work was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def work_params
      params.expect(work: [ :user_id, :work_on, :start_at, :end_at, :location, :body, :approved ])
    end
end
