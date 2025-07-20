# frozen_string_literal: true

require_relative 'naming'
require_relative 'special_cases'
require_relative 'basic_test_generator'

module AUCoreTestKit
  class Generator
    class ReadTestGenerator < BasicTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          ig_metadata.groups
                     .reject { |group| SpecialCases.exclude_group? group }
                     .select { |group| read_interaction(group).present? }
                     .each { |group| new(group, base_output_dir, ig_metadata).generate }
        end

        def read_interaction(group_metadata)
          group_metadata.interactions.find { |interaction| interaction[:code] == 'read' }
        end
      end

      attr_accessor :group_metadata, :base_output_dir, :ig_metadata

      self.template_type = 'read'

      def initialize(group_metadata, base_output_dir, ig_metadata)
        self.group_metadata = group_metadata
        self.base_output_dir = base_output_dir
        self.ig_metadata = ig_metadata
      end

      def read_interaction
        self.class.read_interaction(group_metadata)
      end

      def profile_identifier
        Naming.snake_case_for_profile(group_metadata)
      end

      def test_id
        "#{ig_metadata.ig_test_id_prefix}_#{group_metadata.reformatted_version}_#{profile_identifier}_read_test"
      end

      def class_name
        "#{Naming.upper_camel_case_for_profile(group_metadata)}ReadTest"
      end

      def resource_collection_string
        if group_metadata.delayed? && resource_type != 'Provenance'
          "scratch.dig(:references, '#{resource_type}')"
        else
          'all_scratch_resources'
        end
      end

      def conformance_expectation
        read_interaction[:expectation]
      end

      def needs_location_id?
        resource_type == 'Location'
      end

      def needs_organization_id?
        resource_type == 'Organization'
      end

      def needs_practitioner_id?
        resource_type == 'Practitioner'
      end

      def needs_practitioner_role_id?
        resource_type == 'PractitionerRole'
      end

      def needs_healthcare_service_id?
        resource_type == 'HealthcareService'
      end

      def generate
        FileUtils.mkdir_p(output_file_directory)
        File.open(output_file_name, 'w') { |f| f.write(output) }

        group_metadata.add_test(
          id: test_id,
          file_name: base_output_file_name
        )
      end
    end
  end
end
