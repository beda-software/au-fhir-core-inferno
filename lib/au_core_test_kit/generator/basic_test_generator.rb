# frozen_string_literal: true

require_relative 'naming'
require_relative 'special_cases'

module AUCoreTestKit
  class Generator
    class BasicTestGenerator
      TEMPLATE_FILES_MAP = {
        'multiple_and_search' => 'multiple_and_search.rb.erb',
        'search' => 'search.rb.erb',
        'chain_search' => 'chain_search.rb.erb',
        'validation' => 'validation.rb.erb',
        'suite' => 'suite.rb.erb',
        'include' => 'include.rb.erb',
        'special_identifier_search' => 'special_identifier_search.rb.erb',
        'special_identifier_chain_search' => 'special_identifier_search.rb.erb',
        'multiple_or_search' => 'multiple_or_search.rb.erb',
        'reference_resolution' => 'reference_resolution.rb.erb',
        'read' => 'read.rb.erb',
        'provenance_revinclude_search' => 'provenance_revinclude_search.rb.erb',
        'group' => 'group.rb.erb',
        'must_support' => 'must_support.rb.erb'
      }.freeze

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
        when 'read'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_read_test"
        when 'multiple_and_search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_multiple_and_search_test"
        when 'search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_search_test"
        when 'chain_search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_chain_search_test"
        when 'validation'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_validation_test"
        when 'include'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_param_names_lodash_string}_include_#{search_identifier.downcase}_search_test"
        when 'special_identifier_search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_#{special_identifier[:display].delete('-').downcase}_search_test"
        when 'special_identifier_chain_search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_#{target_identifier[:display].downcase}_chain_search_test"
        when 'multiple_or_search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_multiple_or_search_test"
        when 'reference_resolution'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_reference_resolution_test"
        when 'provenance_revinclude_search'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_#{search_identifier}_search_test"
        when 'must_support'
          "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_must_support_test"
        when 'suite'
        when 'group'
        else
          raise("Unknown test_id for type: #{template_type}")
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
    end
  end
end
