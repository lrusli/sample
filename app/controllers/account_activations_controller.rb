class AccountActivationsController < ApplicationController
  def edit
  	user = User.find_by(email: params[:email])
  	if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
  		flash[:success] = "Your account is now activated."
  		log_in user
  		redirect_to user
  	else
  		flash[:danger] = "We weren’t able to activate your account."
  		redirect_to root_url
  	end
  end
end
