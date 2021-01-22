require 'fastlane/action'

module Fastlane
  module Actions
    class BmslackAction < Action
      def self.run(params)
        message_text = params[:message_text]
        is_exception = params[:is_exception] || false
        if is_exception
          self.slack_func_notify_error_in_lane(message_text)
        else
          self.slack_func_notify(message_text)
        end       
        UI.message("Message sent to Slack!")
      end

      def self.description
        "Sends a message to a Slack chat specified in the SLACK_URL environment variable"
      end

      def self.authors
        ["Bemobile"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Sends a message to a Slack webhook. The message must be passed to the function as a parameter named message_text. 
         To specify that the message comes from an exception or not, we must pass the is_exception parameter.
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
          FastlaneCore::ConfigItem.new(key: :is_exception,
                                   env_name: "IS_EXCEPTION",
                                description: "Flag that indicates if the message is from an exception",
                                   optional: true,
                                       type: Boolean)
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.slack_func_notify(message_text)
        other_action.slack(
            message: message_text,
            success: true,
            default_payloads: [:lane, :git_branch, :git_author],
            icon_url: ENV["SLACK_ICON"],
            username: "Bemobile Fastlane Plugin - #{ENV["PRIVATE_APP_NAME"]}")
      end

      
      #Notify an error of the lane and show the error that fastlane has
      def self.slack_func_notify_error_in_lane(message_text)
        payload = {
            "Build Date" => Time.new.to_s,
            "Error Message" => message_text
        }

        other_action.slack(
            message: "#{ENV["PRIVATE_APP_NAME"]} App build stop with error",
            success: false,
            icon_url: ENV["SLACK_ICON"],
            username: "Bemobile Fastlane Plugin - #{ENV["PRIVATE_APP_NAME"]}",
            payload: payload)

      end

    end
  end
end
