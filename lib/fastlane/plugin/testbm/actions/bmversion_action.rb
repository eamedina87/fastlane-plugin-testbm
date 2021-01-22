require 'fastlane/action'

module Fastlane
  module Actions
    class BmversionAction < Action
      def self.run(params)
        platform_type = params[:platform_type]
        self.version_func_get_version(platform_type)
      end

      def self.description
        "TODO"
      end

      def self.authors
        ["Bemobile"]
      end

      def self.return_value
        "TODO. If your method provides a return value, you can describe here what it does"
      end

      def self.details
        "TODO"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :platform_type,
                                   env_name: "PLATFORM_TYPE",
                                description: "The platform, can be Android or iOS",
                                   optional: false,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        true
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
