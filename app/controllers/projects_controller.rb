#encoding: utf-8
require 'sanitize'

class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
  before_action :set_project, only: [:edit, :update, :destroy]
  before_action :sanitize, only: [:update, :create]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Проект создан.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Проект изменен.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Проект удален.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
      if @project.public or @project.user == current_user
        @project
      else
        @project = nil
      end
    end

  def sanitize
    project_params[:short_desc] = Sanitize.clean(project_params[:short_desc], Sanitize::Config::RELAXED)
    project_params[:full_desc] = Sanitize.clean(project_params[:full_desc], Sanitize::Config::RELAXED)
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      permitted_attrs = [:name, :short_desc, :full_desc, :photo, :markup_type, :project_status]
      permitted_attrs << :public if @project.present? && @project.user == current_user
      params.require(:project).permit(permitted_attrs)
    end
end
