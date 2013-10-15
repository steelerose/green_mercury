class MemberApplicationsController < ApplicationController
  skip_before_filter :member_or_mentor

  def new
    @member_application = MemberApplication.new(user_uuid: current_user.uuid)
  end

  def create
    @member_application = MemberApplication.new(member_application_params)
    if @member_application.save
      flash[:notice] = 'Application Submitted'
      redirect_to root_path
    else
      render 'new'
    end
  end

private

  def member_application_params
    params.require(:member_application).permit(:content, :user_uuid)
  end
end