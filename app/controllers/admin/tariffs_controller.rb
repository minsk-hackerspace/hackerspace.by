# frozen_string_literal: true

module Admin
  class TariffsController < ApplicationController
    load_and_authorize_resource
    before_action :set_tariff, only: %i[show edit update destroy]

    # GET /admin/tariffs
    # GET /admin/tariffs.json
    def index
      @tariffs = Tariff.all
    end

    # GET /admin/tariffs/1
    # GET /admin/tariffs/1.json
    def show; end

    # GET /admin/tariffs/new
    def new
      @tariff = Tariff.new
    end

    # GET /admin/tariffs/1/edit
    def edit; end

    # POST /admin/tariffs
    # POST /admin/tariffs.json
    def create
      @tariff = Tariff.new(tariff_params)

      respond_to do |format|
        if @tariff.save
          format.html { redirect_to [:admin, @tariff], notice: 'Tariff was successfully created.' }
          format.json { render :show, status: :created, location: @tariff }
        else
          format.html { render :new }
          format.json { render json: @tariff.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/tariffs/1
    # PATCH/PUT /admin/tariffs/1.json
    def update
      respond_to do |format|
        if @tariff.update(tariff_params)
          format.html { redirect_to [:admin, @tariff], notice: 'Tariff was successfully updated.' }
          format.json { render :show, status: :ok, location: @tariff }
        else
          format.html { render :edit }
          format.json { render json: @tariff.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/tariffs/1
    # DELETE /admin/tariffs/1.json
    def destroy
      @tariff.destroy
      respond_to do |format|
        format.html { redirect_to admin_tariffs_url, notice: 'Tariff was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_tariff
      @tariff = Tariff.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tariff_params
      params.require(:tariff).permit(:ref_name, :name, :description, :access_allowed, :monthly_price,
                                     :accessible_to_user)
    end
  end
end
