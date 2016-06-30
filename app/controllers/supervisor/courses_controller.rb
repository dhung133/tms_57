class Supervisor::CoursesController < ApplicationController
  before_action :logged_in_user, :verify_supervisor
  before_action :find_course, except: [:index, :new, :create] 

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
    @subjects = Subject.all
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t "courses.created"
      redirect_to supervisor_courses_path
    else
      render :new
    end
  end

  def show
    @user_courses = @course.user_courses
    @supervisors = @user_courses.select{|user_course| user_course.user.supervisor?}
    @trainees = @user_courses.select{|user_course| user_course.user.trainee?}
    @activities = (Activity.find_with @course).desc
  end

  def edit
    @subjects = Subject.all
  end

  def update
    if @course.update course_params
      flash[:success] = t "courses.update"
      redirect_to supervisor_course_path @course
    else
      render :edit
    end
  end

  def destroy
    if @course.destroy
      flash[:success] = t "courses.deleted"
    else
      flash[:danger] = t "courses.empty"
    end
    redirect_to supervisor_courses_path
  end

  private
  def course_params
    params.require(:course).permit :name, :description, subject_ids: []
  end

  def find_course
    @course = Course.find_by id: params[:id]
    if @course.nil?
      flash[:danger] = t "courses.empty"
      redirect_to root_url
    end
  end
end
