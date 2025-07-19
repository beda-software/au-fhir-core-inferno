# frozen_string_literal: true

require_relative 'naming'
require_relative 'special_cases'

module AUCoreTestKit
  class Generator
    class BasicTestGenerator
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

      def module_name
        "#{ig_metadata.ig_module_name_prefix}#{group_metadata.reformatted_version.upcase}"
      end

      def resource_type
        group_metadata.resource
      end
    end
  end
end
