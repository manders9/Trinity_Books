class IdentitiesController < ApplicationController
  def index
    @identities = current_user.identities if current_user
  end

  def all
    omniauth = request.env["omniauth.auth"]
    identity = Identity.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if identity
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, identity.user)
    elsif current_user
      current_user.identities.create!(identity_params)
      flash[:notice] = "Authentication successful."
      redirect_to root_path
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect_to root_url
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
  alias_method :twitter, :all

  def destroy
    @identity = current_user.identities.find(params[:id])
    @identity.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to root_path
  end

  private

  def identity_params
    params.require(:identity).permit(
      :provider,
      :uid
      )
  end
end
