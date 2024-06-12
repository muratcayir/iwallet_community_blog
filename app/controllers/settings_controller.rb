class SettingsController < ApplicationController
  def change_locale
    I18n.locale = params[:locale]
    redirect_back(fallback_location: root_path)
  end
end
