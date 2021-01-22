require 'fastlane/action'
require_relative '../helper/build_helper'

module Fastlane
  module Actions
    class BuildAndroidAction < Action
      def self.run(params)
        UI.message("Build ios action")
       
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
        #   FastlaneCore::ConfigItem.new(key: :person_name,
        #                            env_name: "PERSON_NAME",
        #                         description: "The person's name",
        #                            optional: false,
        #                                type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end

      ##### Functions #######

      ##Install gradle dependencies and compile version 
      def self.build_func_gradle(app_information:)
        gradle(task: 'assemble', 
              build_type: app_information[:android][:build_type],
              project_dir: app_information[:android][:project_dir])
      end
    end
  end
end
