# frozen_string_literal: true

class NewsController < ApplicationController
  #  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
  load_and_authorize_resource

  def index
    @news = News.order(created_at: :desc).all
  end

  def show; end

  def new
    @news = News.new
  end

  def edit; end

  def create
    @news = News.new(news_params)
    @news.user = current_user

    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: 'News was successfully created.' }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to news_index_path, notice: 'News was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:title, :short_desc, :description, :photo, :public, :markup_type,
                                 :show_on_homepage_till_date, :show_on_homepage, :url)
  end
end
