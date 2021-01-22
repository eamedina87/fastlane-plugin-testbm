require 'fastlane/action'

module Fastlane
  module Actions
    class BmdistributionAction < Action
      def self.run(params)
        app_information = params[:app_information]
        platform_type = params[:platform_type]
        self.distribution_func_send_to_firebase(app_information, platform_type)  
        UI.message("Version distributed!")
      end

      def self.description
        "Distributes an app version via firebase, testflight, browsertack or the play store."
      end

      def self.authors
        ["Bemobile"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "TODO"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_information,
                                   env_name: "APP_INFORMATION",
                                description: "The app information including name, version.",
                                   optional: false,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :platform_type,
                                   env_name: "PLATFORM_TYPE",
                                description: "Indicates platform wheter android or ios",
                                   optional: false,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.distribution_func_send_to_firebase(app_information, platform_type)
        version_info = Helper::BmHelper.version_func_get_version(platform_type:platform_type)
        fabric_build_number = version_info[:build_number]
    
        # set other information for fabric
        fabric_app_name = app_information[:app_name]
        fabric_changelogs_description = app_information[:changelog]
        fabric_notes = "Version #{fabric_build_number} from #{fabric_app_name} \n\n#{fabric_changelogs_description}"    
        fabric_groups = nil
        fabric_mails = nil
    
        # SEND VERSION
        fabric_groups = ""
        fabric_mails = ""
        firebase_app_id = ""
        if platform_type == Helper::BmHelper::CONST_PROJECT_TYPE__IOS
            if app_information[:environment] == Helper::BmHelper::CONST_PROJECT_ENVIRONMENT__PROD
                fabric_groups = ENV["PRIVATE_IOS_FABRIC_GROUPS_PROD"]
                fabric_mails = ENV["PRIVATE_IOS_FABRIC_MAILS_PROD"]
                firebase_app_id = ENV["PRIVATE_FIREBASE_APP_ID_IOS_PROD"]
            else 
                fabric_groups = ENV["PRIVATE_IOS_FABRIC_GROUPS_DEV"]
                fabric_mails = ENV["PRIVATE_IOS_FABRIC_MAILS_DEV"]
                firebase_app_id = ENV["PRIVATE_FIREBASE_APP_ID_IOS_DEV"]
            end 
        elsif
            if app_information[:environment] == Helper::BmHelper::CONST_PROJECT_ENVIRONMENT__PROD
                fabric_groups = ENV["PRIVATE_ANDROID_FABRIC_GROUPS_PROD"]
                fabric_mails = ENV["PRIVATE_ANDROID_FABRIC_MAILS_PROD"]
                firebase_app_id = ENV["PRIVATE_FIREBASE_APP_ID_ANDROID_PROD"]
            else 
                fabric_groups = ENV["PRIVATE_ANDROID_FABRIC_GROUPS_DEV"]
                fabric_mails = ENV["PRIVATE_ANDROID_FABRIC_MAILS_DEV"]
                firebase_app_id = ENV["PRIVATE_FIREBASE_APP_ID_ANDROID_DEV"]
            end
        end
    
        firebase_login_token = ENV["FIREBASE_LOGIN_TOKEN"]
        if fabric_groups.length > 0 && fabric_mails.length > 0
            other_action.firebase_app_distribution(app: firebase_app_id, firebase_cli_token: firebase_login_token, testers: fabric_mails, groups: fabric_groups, release_notes: fabric_notes)
        elsif fabric_groups.length > 0
            other_action.firebase_app_distribution(app: firebase_app_id, firebase_cli_token: firebase_login_token, groups: fabric_groups, release_notes: fabric_notes)
        elsif fabric_mails.length > 0
            other_action.firebase_app_distribution(app: firebase_app_id, firebase_cli_token: firebase_login_token, testers: fabric_mails, release_notes: fabric_notes)
        else
            other_action.firebase_app_distribution(app: firebase_app_id, firebase_cli_token: firebase_login_token, release_notes: fabric_notes)
        end
    
        message_text = "#{app_information[:app_name]} App successfully released to Firebase!"
        other_action.bmslack(message_text: message_text)
      end

      def self.distribution_func_send_to_browserstack(app_information, apk_location, platform_type)
        version_info = Helper::BmHelper.version_func_get_version(platform_type:platform_type)
        username = ENV["BROWSERSTACK_USERNAME"]
        access_key = ENV["BROWSERSTACK_ACCESS_KEY"]
    
        apk_path = File.dirname(apk_location)
        apk_new_path = apk_path + "/#{app_information[:app_name]}_#{app_information[:environment]}_#{version_info[:version_number]}_#{version_info[:build_number]}.apk"
        File.rename(apk_location, apk_new_path)
        other_action.upload_to_browserstack_app_live(browserstack_username: username, browserstack_access_key: access_key, file_path: apk_new_path)
      end
  
      def self.distribution_func_testflight(app_information)  
        version_info = Helper::BmHelper.version_func_get_version(platform_type:Helper::BmHelper::CONST_PROJECT_TYPE__IOS)
        testflight_notes = "Version #{version_info[:build_number]} from #{app_information[:app_name]} \n\n#{app_information[:changelog]}"
    
        testflight_groups = nil
        if app_information[:environment] == Helper::BmHelper::CONST_PROJECT_ENVIRONMENT__PROD
            testflight_groups = ENV["PRIVATE_FABRIC_GROUPS_PROD"]
        else 
            testflight_groups = ENV["PRIVATE_FABRIC_GROUPS_DEV"]
        end 
        testflight_groups = testflight_groups.split(",")
    
        # upload to Testflight
        other_action.pilot(
            changelog: testflight_notes,
            skip_submission: false,
            skip_waiting_for_build_processing: true,
            distribute_external: true,
            app_identifier: version_info[:ios][:bundle_id],
            groups: testflight_groups)
        
        message_text = "#{app_information[:app_name]} App successfully released to TestFlight!"
        other_action.bmslack(message_text: message_text)                                        
      end
  
      def self.distribution_func_itunes_connect(app_information)  
        other_action.appstore(force: true, skip_screenshots: true)
        message_text = "#{app_information[:app_name]} App successfully uploaded to Itunes Connect!"
        other_action.bmslack(message_text: message_text)     
      end

    end
  end
end
