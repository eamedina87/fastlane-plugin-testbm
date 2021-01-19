require 'fastlane/action'
require_relative '../helper/testbm_helper'

module Fastlane
  module Actions
    class ChatAction < Action
      def self.run(params)
        slack_icon = params[:slack_icon]
        message_text = params[:message_text]
        other_action.slack(
          message: message_text,
          success: true,
          icon_url: slack_icon,
          username: "Bemobile Fastlane Plugin - #{ENV["PRIVATE_APP_NAME"]}"
        )       
        Helper::TestbmHelper.slack_func_notify("Message from")
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
          FastlaneCore::ConfigItem.new(key: :message_text,
                                   env_name: "MESSAGE_TEXT",
                                description: "The chat message to be sent to Slack",
                                   optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :slack_icon,
                                    env_name: "SLACK_ICON",
                                description: "The icon to be posted to Slack",
                                    optional: false,
                                        type: String)
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
