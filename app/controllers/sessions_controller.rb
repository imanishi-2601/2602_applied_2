class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    name = params[:name]
    password = params[:password]

    if (user = User.find_by(name: name))&.authenticate(password)
      start_new_session_for user
      redirect_to user_path(user), notice: "Logged in successfully."
    else
      redirect_to new_session_path, alert: "Try another name or password."
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Logged out successfully.", status: :see_other
  end
end