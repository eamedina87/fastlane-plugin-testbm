require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class BuildHelper
      # class methods that you define here become available in your action
      # as `Helper::BuildHelper.your_method`
      #
      def self.build_func_get_correct_export_method_name(match_type)
        #if match type is adhoc or appstore
        #export_method needs to be ad-hoc or app-store
        #this is a fix to use just one name for types
        export_method = match_type
        
        if export_method == "adhoc"
            export_method = "ad-hoc"
        end
        if export_method == "appstore"
            export_method = "app-store"
        end
    
        return export_method
    end
    end
  end
end
