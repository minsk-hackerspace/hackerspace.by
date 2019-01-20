class ThanksController < ApplicationController
#  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  # GET /thanks
  # GET /thanks.json
  def index
    @thanks = Thank.all
  end

  # GET /thanks/1
  # GET /thanks/1.json
  def show
  end

  # GET /thanks/new
  def new
    @thank = Thank.new
  end

  # GET /thanks/1/edit
  def edit
  end

  # POST /thanks
  # POST /thanks.json
  def create
    @thank = Thank.new(thank_params)
    @thank.user = current_user

    respond_to do |format|
      if @thank.save
        format.html { redirect_to @thank, notice: 'Thank was successfully created.' }
        format.json { render :show, status: :created, location: @thank }
      else
        format.html { render :new }
        format.json { render json: @thank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /thanks/1
  # PATCH/PUT /thanks/1.json
  def update
    respond_to do |format|
      if @thank.update(thank_params)
        format.html { redirect_to @thank, notice: 'Thank was successfully updated.' }
        format.json { render :show, status: :ok, location: @thank }
      else
        format.html { render :edit }
        format.json { render json: @thank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /thanks/1
  # DELETE /thanks/1.json
  def destroy
    @thank.destroy
    respond_to do |format|
      format.html { redirect_to thanks_url, notice: 'Thank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thank
      @thank = Thank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def thank_params
      permitted_attrs = [:name, :short_desc, :full_desc, :photo, :markup_type]
      permitted_attrs << :public if @project.present? && @project.user == current_user

      result_params = params.require(:thank).permit(permitted_attrs)
      result_params[:short_desc] = Sanitize.clean(result_params[:short_desc], Sanitize::Config::RELAXED)
      result_params[:full_desc] = Sanitize.clean(result_params[:full_desc], Sanitize::Config::RELAXED)
      result_params
    end
end
