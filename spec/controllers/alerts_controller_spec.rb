require "rails_helper"

describe AlertsController do
  describe "#create" do
    context "without recent alerts" do
      it "notifies recipients" do
        recipient = "https://women.slack.com/services/hooks/slackbot?token=CZGuvWvq4Jz86xKTlfr9U6iZ&channel=%23notifications"
        notification_request = stub_request(:post, recipient).
          to_return(:status => 200)

        post(
          :create,
          description: "Test",
          recipients: recipient,
          current_number: 2,
          threshold: 1
        )

        expect(notification_request).to have_been_requested
      end
    end

    context "with recent alerts" do
      it "does not notify recipients" do
        description = "testing"
        recipient = "https://women.slack.com/services/hooks/slackbot?token=CZGuvWvq4Jz86xKTlfr9U6iZ&channel=%23notifications"
        Alert.create(description: description, recipient: recipient)
        notification_request = stub_request(:post, recipient).
          to_return(:status => 200)

        post(
          :create,
          description: description,
          recipients: recipient,
          current_number: 2,
          threshold: 1
        )

        expect(notification_request).not_to have_been_requested
      end
    end
  end
end
