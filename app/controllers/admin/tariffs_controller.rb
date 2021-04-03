class Admin::TariffsController < ApplicationController
  load_and_authorize_resource
  before_action :set_admin_tariff, only: [:show, :edit, :update, :destroy]

  # GET /admin/tariffs
  # GET /admin/tariffs.json
  def index
    @admin_tariffs = Tariff.all
  end

  # GET /admin/tariffs/1
  # GET /admin/tariffs/1.json
  def show
  end

  # GET /admin/tariffs/new
  def new
    @admin_tariff = Tariff.new
  end

  # GET /admin/tariffs/1/edit
  def edit
  end

  # POST /admin/tariffs
  # POST /admin/tariffs.json
  def create
    @admin_tariff = Tariff.new(admin_tariff_params)

    respond_to do |format|
      if @admin_tariff.save
        format.html { redirect_to @admin_tariff, notice: 'Tariff was successfully created.' }
        format.json { render :show, status: :created, location: @admin_tariff }
      else
        format.html { render :new }
        format.json { render json: @admin_tariff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tariffs/1
  # PATCH/PUT /admin/tariffs/1.json
  def update
    respond_to do |format|
      if @admin_tariff.update(admin_tariff_params)
        format.html { redirect_to @admin_tariff, notice: 'Tariff was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_tariff }
      else
        format.html { render :edit }
        format.json { render json: @admin_tariff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tariffs/1
  # DELETE /admin/tariffs/1.json
  def destroy
    @admin_tariff.destroy
    respond_to do |format|
      format.html { redirect_to admin_tariffs_url, notice: 'Tariff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_tariff
      @admin_tariff = Tariff.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_tariff_params
      params.require(:admin_tariff).permit(:ref_name, :name, :description, :access_allowed, :monthly_price)
    end
end
