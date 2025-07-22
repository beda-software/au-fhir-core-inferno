# frozen_string_literal: true

require 'json'

module AUCoreTestKit
  class Generator
    class GeneratorConfigKeeper
      CONFIG_FILE_PATH = File.join(File.dirname(__FILE__), '../../../config.json')
      CONFIG_ROOT_KEY = 'hl7.fhir.au.core'

      attr_reader :config, :versions

      def initialize(config_file_path = CONFIG_FILE_PATH)
        @config_file_path = config_file_path
        load_config
      end

      def reload
        load_config
      end

      def metadata
        @config['metadata'] || {}
      end

      def description
        metadata['description']
      end

      def last_updated
        metadata['last_updated']
      end

      def version
        metadata['version']
      end

      def supported_versions
        @versions
      end

      def paths
        @config['paths'] || {}
      end

      def ig_packages_path
        paths['ig_packages']
      end

      def main_file_path
        paths['main_file']
      end

      def naming_mappings
        configs['NAMING'] || {}
      end

      def constant_name_for_profile(profile_url)
        naming_mappings[profile_url]
      end

      def skip_profiles
        configs.dig('SKIP_PROFILES', 'profiles') || []
      end

      def skip_profile?(profile_url)
        skip_profiles.include?(profile_url)
      end

      def special_cases
        configs['SPECIAL_CASES'] || {}
      end

      def category_first_profiles
        special_cases.dig('ALL_VERSION_CATEGORY_FIRST_PROFILES', 'profiles') || []
      end

      def category_first_profile?(profile_url, version = nil)
        category_first_profiles.include?(profile_url) ||
          version_specific_category_first_profiles(version)&.include?(profile_url)
      end

      def patient_first_profiles
        special_cases.dig('ALL_VERSION_PATIENT_FIRST_PROFILES', 'profiles') || []
      end

      def patient_first_profile?(profile_url)
        patient_first_profiles.include?(profile_url)
      end

      def id_first_profiles
        special_cases.dig('ALL_VERSION_ID_FIRST_PROFILES', 'profiles') || []
      end

      def id_first_profile?(profile_url)
        id_first_profiles.include?(profile_url)
      end

      def name_first_profiles
        special_cases.dig('ALL_VERSION_NAME_FIRST_PROFILES', 'profiles') || []
      end

      def name_first_profile?(profile_url)
        name_first_profiles.include?(profile_url)
      end

      def version_specific_profiles(version = nil)
        return {} if version.nil?

        special_cases.dig('VERSION_SPECIFIC_PROFILES', 'profiles') || {}
      end

      def version_specific_category_first_profiles(version = nil)
        return [] if version.nil?

        []
      end

      def first_search_params(profile_url, resource, version = nil)
        if category_first_profile?(profile_url, version)
          %w[patient category]
        elsif patient_first_profile?(profile_url)
          ['patient']
        elsif id_first_profile?(profile_url)
          ['_id']
        elsif name_first_profile?(profile_url)
          ['name']
        elsif resource == 'Observation'
          %w[patient code]
        elsif resource == 'MedicationRequest'
          ['patient']
        elsif resource == 'CareTeam'
          %w[patient status]
        else
          ['patient']
        end
      end

      private

      def load_config
        @raw_config = JSON.parse(File.read(@config_file_path))
        @config = @raw_config[CONFIG_ROOT_KEY] || {}
        @versions = @config['version'] || []
      end

      def configs
        @config['configs'] || {}
      end
    end
  end
end
