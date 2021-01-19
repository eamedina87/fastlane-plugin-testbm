require 'fastlane/action'

module Fastlane
  module Actions
    class BmslackAction < Action
      def self.run(params)
        slack_icon = params[:slack_icon]
        message_text = params[:message_text]
        other_action.slack(
          message: message_text,
          success: true,
          icon_url: slack_icon,
          default_payloads: [:lane, :git_branch, :git_author],
          username: "Bemobile Fastlane Plugin - #{ENV["PRIVATE_APP_NAME"]}"
        )       
        UI.message("Message sent to Slack!")
      end

      def self.description
        "Sends a message to a Slack chat specified in the SLACK_URL environment variable."
      end

      def self.authors
        ["Erick, Legna @ Bemobile."]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Sends a message to a Slack webhook. The message must be passed to the function as a parameter named message_text. 
         An icon must be specified as a param named slack_icon, or as an environment variable named SLACK_ICON.
         The webhook URL must be specified as an environment variable called SLACK_URL.
         The username which sends the message can be appendend with the environment variable called PRIVATE_APP_NAME."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :message_text,
                                   env_name: "MESSAGE_TEXT",
                                description: "The chat message to be sent to Slack",
                                   optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :slack_icon,
                                    env_name: "SLACK_ICON",
                                description: "The user icon to be posted to Slack",
                                    optional: false,
                                        type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
