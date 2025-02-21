class InquiriesController < ApplicationController
  before_action :set_inquiry, only: %i[ show edit update destroy ]
  before_action :authenticate, except: [:show, :new, :create]

  # GET /inquiries
  def index
    @inquiries = Inquiry.all
  end

  # GET /inquiries/1
  def show
  end

  # GET /inquiries/new
  def new
    @inquiry = Inquiry.new
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  def create
    @inquiry = Inquiry.new(inquiry_params)

    if @inquiry.save
      InquiriesMailer.sent(to: @inquiry.email).deliver_later
      InquiriesMailer.received.deliver_later
      redirect_to @inquiry, notice: "Inquiry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inquiries/1
  def update
    if @inquiry.update(inquiry_params)
      redirect_to @inquiry, notice: "Inquiry was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /inquiries/1
  def destroy
    @inquiry.destroy!
    redirect_to inquiries_path, notice: "Inquiry was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inquiry
      @inquiry = Inquiry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def inquiry_params
      params.expect(inquiry: [ :name, :email, :purpose, :body, images:[]])
    end
end
