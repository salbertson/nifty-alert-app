class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Alert.create(alert_params)
  end

  private

  def alert_params
    params.permit(
      :description,
      :recipients,
      :current_number,
      :threshold
    ).merge(recipients: params[:recipients].split(","))
  end
end
