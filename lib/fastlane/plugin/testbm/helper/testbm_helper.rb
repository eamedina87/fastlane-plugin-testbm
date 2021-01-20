require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class TestbmHelper
      # class methods that you define here become available in your action
      # as `Helper::TestbmHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the testbm plugin helper!")
      end

      #Notify via slack channel a generic message with the default payloads
      def self.slack_func_notify(message_text)
        other_action.slack(
            message: message_text,
            success: true,
            default_payloads: [:lane, :git_branch, :git_author],
            icon_url: ENV["SLACK_ICON"],
            username: "fastlane - #{ENV["PRIVATE_APP_NAME"]}")
      end

    end
  end
end
