class ReportsController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @reports = current_user.reports
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      flash[:success] = t "reports.success"
      redirect_to reports_path
    else
      flash[:danger] = t "reports.fail"
      redirect_to root_url
    end
  end

  private
  def report_params
    params.require(:report).permit :content
  end
end
