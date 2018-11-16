# CoursesController
class CoursesController < ApplicationController
  before_action :set_course, only: [:show]
  before_action :set_course_admin, only: [:edit, :update, :destroy, :inspect]
  authorize_resource

  def edit
    cookies[:edited_course] = params[:id]
  end

  def update
    @course.update(course_params)
    @errors = @course.errors
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.save
    redirect_to administration_path if @course.valid?
    @errors = @course.errors
  end

  def show
    @course = Course.includes(lectures: [:teacher, :term, :chapters])
                    .find_by_id(params[:id])
    # id of the current course is stored in a cookie
    # the cookie is used to keep track of the course in the course dropdown
    cookies[:current_course] = params[:id]
    @lectures = @course.subscribed_lectures_by_date(current_user)
    # determine which lecture gets the top position in the lecture carousel
    @front_lecture = @course.front_lecture(current_user, params[:active].to_i)
  end

  def inspect
  end

  def destroy
    @course.destroy
    redirect_to administration_path
  end

  private

  def set_course
    @course = Course.find_by_id(params[:id])
    return if @course.present?
    redirect_to :root, alert: 'Ein Kurs mit der angeforderten id existiert ' \
                              'nicht.'
  end

  def set_course_admin
    @course = Course.find_by_id(params[:id])
    return if @course.present?
    redirect_to administration_path
  end

  def course_params
    params.require(:course).permit(:title, :short_title, :news,
                                   tag_ids: [],
                                   preceding_course_ids: [],
                                   editor_ids: [])
  end
end
