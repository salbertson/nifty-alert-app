class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    recipients.each do |recipient|
      Alert.create!(
        description: params[:description],
        recipient: recipient,
        current_number: params[:current_number],
        threshold: params[:threshold]
      )

      if no_recent_alert_for(recipient) &&
        recipient.include?("slack.com/services/hooks")
        Rails.logger message
        Typhoeus.post(recipient, body: message)
      end
    end

    head 201
  end

  private

  def recipients
    params[:recipients].split(",")
  end

  def alert_params
    params.permit(
      :description,
      :recipients,
      :current_number,
      :threshold
    )
  end

  def no_recent_alert_for(recipient)
    recent_alert_count = Alert.
      where(description: params[:description], recipient: recipient).
      where("created_at < ?", 15.minutes.ago).
      count
    recent_alert_count == 0
  end

  def difference
    params[:current_number].to_i - params[:threshold].to_i
  end

  def message
    "Your #{params[:description]} is #{difference} over the threshold, you better check on it. (via #{root_url})"
  end
end
