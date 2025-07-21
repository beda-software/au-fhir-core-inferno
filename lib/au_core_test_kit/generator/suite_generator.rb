# frozen_string_literal: true

require_relative 'naming'
require_relative 'special_cases'
require_relative 'basic_test_generator'

module AUCoreTestKit
  class Generator
    class SuiteGenerator < BasicTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          new(ig_metadata, base_output_dir).generate
        end
      end

      attr_accessor :ig_metadata, :base_output_dir

      self.template_type = TEMPLATE_TYPES[:SUITE]

      def initialize(ig_metadata, base_output_dir)
        self.ig_metadata = ig_metadata
        self.base_output_dir = base_output_dir
      end

      def version_specific_message_filters
        []
      end

      def base_output_file_name
        "#{ig_metadata.ig_test_id_prefix}_test_suite.rb"
      end

      def module_name
        "#{ig_metadata.ig_module_name_prefix}#{ig_metadata.reformatted_version.upcase}"
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def suite_id
        "#{ig_metadata.ig_test_id_prefix}_#{ig_metadata.reformatted_version}"
      end

      def fhir_api_group_id
        "#{ig_metadata.ig_test_id_prefix}_#{ig_metadata.reformatted_version}_fhir_api"
      end

      def title
        "#{ig_metadata.ig_title} #{ig_metadata.ig_version}"
      end

      def ig_identifier
        version = ig_metadata.ig_version[1..] # Remove leading 'v'
        "#{ig_metadata.ig_id}##{version}"
      end

      def ig_link
        case ig_metadata.ig_version
        when 'v0.3.0-ballot'
          'http://hl7.org.au/fhir/core/0.3.0-ballot'
        end
      end

      def generate
        File.open(output_file_name, 'w') { |f| f.write(output) }
      end

      def groups
        ig_metadata.ordered_groups.compact
                   .reject { |group| SpecialCases.exclude_group? group }
      end

      def group_id_list
        @group_id_list ||=
          groups.map(&:id)
      end

      def group_file_list
        @group_file_list ||=
          groups.map { |group| group.file_name.delete_suffix('.rb') }
      end

      def capability_statement_file_name
        # "../../custom_groups/#{ig_metadata.ig_version}/capability_statement_group"
        '../../custom_groups/v0.3.0-ballot/capability_statement_group'
      end

      def capability_statement_group_id
        # "au_core_#{ig_metadata.reformatted_version}_capability_statement"
        'au_core_v030_ballot_capability_statement'
      end
    end
  end
end
