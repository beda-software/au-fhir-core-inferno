# frozen_string_literal: true

require_relative 'naming'
require_relative 'special_cases'
require_relative 'generator_constants'

module AUCoreTestKit
  class Generator
    class BasicTestGenerator
      include GeneratorConstants

      class_attribute :template_type

      def template
        @template ||= File.read(File.join(__dir__, 'templates', template_file_name))
      end

      def output_file_directory
        File.join(base_output_dir, profile_identifier)
      end

      def output_file_name
        File.join(output_file_directory, base_output_file_name)
      end

      def base_output_file_name
        "#{class_name.underscore}.rb"
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def module_name
        "#{ig_metadata.ig_module_name_prefix}#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end

      def test_id
        case template_type
        when TEMPLATE_TYPES[:READ]
          "#{basic_test_id}_read_test"
        when TEMPLATE_TYPES[:MULTIPLE_AND_SEARCH]
          "#{basic_test_id_with_search}_multiple_and_search_test"
        when TEMPLATE_TYPES[:SEARCH]
          "#{basic_test_id_with_search}_search_test"
        when TEMPLATE_TYPES[:CHAIN_SEARCH]
          "#{basic_test_id_with_search}_chain_search_test"
        when TEMPLATE_TYPES[:VALIDATION]
          "#{basic_test_id}_validation_test"
        when TEMPLATE_TYPES[:INCLUDE]
          "#{basic_test_id}_#{search_param_names_lodash_string}_include_#{search_identifier.downcase}_search_test"
        when TEMPLATE_TYPES[:SPECIAL_IDENTIFIER_SEARCH]
          "#{basic_test_id}_#{search_identifier}_#{special_identifier[:display].delete('-').downcase}_search_test"
        when TEMPLATE_TYPES[:MULTIPLE_OR_SEARCH]
          "#{basic_test_id_with_search}_multiple_or_search_test"
        when TEMPLATE_TYPES[:REFERENCE_RESOLUTION]
          "#{basic_test_id}_reference_resolution_test"
        when TEMPLATE_TYPES[:PROVENANCE_REVINCLUDE_SEARCH]
          "#{basic_test_id_with_search}_search_test"
        when TEMPLATE_TYPES[:MUST_SUPPORT]
          "#{basic_test_id}_must_support_test"
        when TEMPLATE_TYPES[:SPECIAL_IDENTIFIER_CHAIN_SEARCH]
        when TEMPLATE_TYPES[:SUITE]
        when TEMPLATE_TYPES[:GROUP]
        else
          raise("Unknown test_id for type: #{template_type}")
        end
      end

      def class_name
        case template_type
        when TEMPLATE_TYPES[:READ]
          "#{basic_class_name}ReadTest"
        when TEMPLATE_TYPES[:MULTIPLE_AND_SEARCH]
          "#{basic_class_name_with_search_capitalize}MultipleAndSearchTest"
        when TEMPLATE_TYPES[:SEARCH]
          "#{basic_class_name_with_search}SearchTest"
        when TEMPLATE_TYPES[:CHAIN_SEARCH]
          "#{basic_class_name_with_search}ChainSearchTest"
        when TEMPLATE_TYPES[:VALIDATION]
          "#{basic_class_name}ValidationTest"
        when TEMPLATE_TYPES[:INCLUDE]
          "#{basic_class_name_with_search}Include#{includes.first['target_resource']}Test"
        when TEMPLATE_TYPES[:SPECIAL_IDENTIFIER_SEARCH]
          "#{basic_class_name_with_search}#{special_identifier[:display].delete('-')}SearchTest"
        when TEMPLATE_TYPES[:MULTIPLE_OR_SEARCH]
          "#{basic_class_name_with_search_capitalize}MultipleOrSearchTest"
        when TEMPLATE_TYPES[:REFERENCE_RESOLUTION]
          "#{basic_class_name}ReferenceResolutionTest"
        when TEMPLATE_TYPES[:PROVENANCE_REVINCLUDE_SEARCH]
          "#{basic_class_name_with_search}SearchTest"
        when TEMPLATE_TYPES[:MUST_SUPPORT]
          "#{basic_class_name}MustSupportTest"
        when TEMPLATE_TYPES[:SUITE]
          "#{ig_metadata.ig_module_name_prefix}TestSuite"
        when TEMPLATE_TYPES[:GROUP]
          "#{Naming.upper_camel_case_for_profile(group_metadata)}Group"
        when TEMPLATE_TYPES[:SPECIAL_IDENTIFIER_CHAIN_SEARCH]
        else
          raise("Unknown class_name for type: #{template_type}")
        end
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.open(output_file_name, 'w') { |f| f.write(output) }

        group_metadata.add_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end

      private

      def template_file_name
        TEMPLATE_FILES_MAP[template_type] || raise("Unknown template type: #{template_type}")
      end

      def basic_test_id
        "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}"
      end

      def basic_test_id_with_search
        "#{basic_test_id}_#{search_identifier}"
      end

      def basic_class_name
        Naming.upper_camel_case_for_profile(group_metadata)
      end

      def basic_class_name_with_search
        "#{basic_class_name}#{search_title}"
      end

      def basic_class_name_with_search_capitalize
        "#{basic_class_name}#{search_title.capitalize}"
      end
    end
  end
end
