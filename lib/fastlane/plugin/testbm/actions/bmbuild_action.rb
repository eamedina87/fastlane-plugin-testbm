require 'fastlane/action'

module Fastlane
  module Actions
    class BmbuildAction < Action
      def self.run(params)
        app_information = params[:app_information]
        other_action.gradle(task:"assemble", build_type: app_information[:android][:build_type])
        UI.message("Version built!")
      end

      def self.description
        "TODO"
      end

      def self.authors
        ["Bemobile"]
      end

      def self.return_value
        "TODO # If your method provides a return value, you can describe here what it does"
      end

      def self.details
        "TODO"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_information,
                                   env_name: "APP_INFORMATION",
                                description: "The app information",
                                   optional: false,
                                       type: Hash)
        ]
      end

      def self.is_supported?(platform)
        true
      end

    end
  end
end
