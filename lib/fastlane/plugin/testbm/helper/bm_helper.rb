require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class BmHelper
      # class methods that you define here become available in your action
      # as `Helper::BmHelper.your_method`
      #

      CONST_PROJECT_TYPE__IOS = "IOS"
      CONST_PROJECT_TYPE__ANDROID = "ANDROID"
      CONST_PROJECT_TYPE__OTHER = "OTHER"

      CONST_PROJECT_ENVIRONMENT__DEV = "dev"
      CONST_PROJECT_ENVIRONMENT__PROD = "prod"

      CONST_PLATFORM__IOS__SIGN_CONFIG_TYPE__DEVELOPMENT = "development"
      CONST_PLATFORM__IOS__SIGN_CONFIG_TYPE__ADDHOC = "adhoc"
      CONST_PLATFORM__IOS__SIGN_CONFIG_TYPE__APPSTORE = "appstore"

      def self.show_message
        UI.message("Hello from the testbm plugin helper!")
      end

      def self.version_func_get_version(platform_type)
        build_number = ""
        version_number = ""
    
        if platform_type == Helper::BmHelper::CONST_PROJECT_TYPE__IOS
            version_number = Actions.lane_context[Actions::SharedValues::VERSION_NUMBER]
            build_number = Actions.lane_context[Actions::SharedValues::BUILD_NUMBER]
        elsif
            version_number = File.read("./../version.name").to_s  
            build_number = File.read("./../version.number").to_s  
        end
    
        {build_number: build_number, version_number: version_number}
      end

    end
  end
end
