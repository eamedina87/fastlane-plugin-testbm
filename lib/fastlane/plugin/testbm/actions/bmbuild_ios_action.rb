require 'fastlane/action'
require_relative '../helper/build_helper'

module Fastlane
  module Actions
    class BuildIosAction < Action
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

      ##Install pods, install and configure certs with given type, compile the ios app with given scheme  
      def self.build_func_match_and_gym(app_information:)

        cocoapods(try_repo_update_on_error: true, podfile: app_information[:ios][:podfile], use_bundle_exec: true)
        
        match(
            type: app_information[:ios][:sign_config_type], 
            readonly: true, 
            clone_branch_directly: true, 
            verbose: true)
      
        export_method = build_func_get_correct_export_method_name(match_type: app_information[:ios][:sign_config_type])
              
        gym(
            scheme: app_information[:ios][:scheme_name],
            export_method: export_method,
            include_symbols: true,
            include_bitcode: true,
            workspace: app_information[:ios][:workspace],
            output_name: "CompiledApp")
      end
    end
  end
end









