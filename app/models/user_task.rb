class UserTask < ActiveRecord::Base
  include Trackable

  after_create :create_activity

  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
  
  private
  def create_activity
    type = Settings.finished
    self.track_activity type, self.user
  end
end
