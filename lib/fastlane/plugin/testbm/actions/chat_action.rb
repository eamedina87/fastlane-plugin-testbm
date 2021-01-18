require 'fastlane/action'

module Fastlane
  module Actions
    class ChatAction < Action
      def self.run(params)
        slack_icon = params(:slack_icon)
        chat_message = params[:chat_message]
        slack_url = params[:slack_url]
        slack(
          message: chat_message,
          success: true,
          slack_url: slack_url,
          default_payloads: [:lane, :git_branch, :git_author],
          icon_url: slack_icon,
          username: "Bemobile Fastlane Plugin"
        )        
        UI.message("Message sent to Slack!")
      end

      def self.description
        "Returns hello world"
      end

      def self.authors
        ["Bemobile"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Just a test plugin"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :chat_message,
                                   env_name: "CHAT_MESSAGE",
                                description: "The chat message to be sent to Slack",
                                   optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :slack_icon,
                                    env_name: "SLACK_ICON",
                                description: "The icon to be posted to Slack",
                                    optional: false,
                                        type: String),
          FastlaneCore::ConfigItem.new(key: :slack_url,
                                    env_name: "SLACK_URL",
                                description: "The webhook's url to where we will post in Slack",
                                    optional: false,
                                        type: String),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
