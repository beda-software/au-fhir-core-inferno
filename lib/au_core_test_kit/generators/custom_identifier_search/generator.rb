# frozen_string_literal: true

require 'inferno_suite_generator/utils/naming'
require 'inferno_suite_generator/utils/registry'
require 'inferno_suite_generator/generators/search_test_generator'

module InfernoSuiteGenerator
  class Generator
    class SpecialIdentifierSearchTestGenerator < SearchTestGenerator
      class << self
        def generate(ig_metadata, base_output_dir, template_path)
          target_groups = ig_metadata.groups.select do |group|
            %w[Patient Organization Practitioner PractitionerRole].include? group.resource
          end
          target_groups.each do |group|
            searches = group.searches.select { |search| search[:names].include? 'identifier' }
            searches.each do |search|
              identifier_arr = case group.resource
                               when 'Patient'
                                 [
                                   {
                                     'display' => 'IHI',
                                     'url' => 'http://ns.electronichealth.net.au/id/hi/ihi/1.0'
                                   },
                                   {
                                     'display' => 'Medicare',
                                     'url' => 'http://ns.electronichealth.net.au/id/medicare-number'
                                   },
                                   {
                                     'display' => 'DVA',
                                     'url' => 'http://ns.electronichealth.net.au/id/dva'
                                   }
                                 ]
                               when 'Organization'
                                 [
                                   {
                                     'display' => 'HPI-O',
                                     'url' => 'http://ns.electronichealth.net.au/id/hi/hpio/1.0'
                                   },
                                   {
                                     'display' => 'ABN',
                                     'url' => 'http://hl7.org.au/id/abn'
                                   }
                                 ]
                               when 'Practitioner'
                                 [
                                   {
                                     'display' => 'HPI-I',
                                     'url' => 'http://ns.electronichealth.net.au/id/hi/hpii/1.0'
                                   }
                                 ]
                               when 'PractitionerRole'
                                 [
                                   {
                                     'display' => 'Medicare',
                                     'url' => 'http://ns.electronichealth.net.au/id/medicare-provider-number'
                                   }
                                 ]
                               else
                                 # do nothing
                               end
              identifier_arr.each do |special_identifier|
                new(group, search, base_output_dir, special_identifier, ig_metadata, template_path).generate
              end
            end
          end
        end
      end

      attr_accessor :group_metadata, :search_metadata, :base_output_dir, :special_identifier, :ig_metadata, :template_path

      self.template_type = TEMPLATE_TYPES[:SPECIAL_IDENTIFIER_SEARCH]

      def initialize(group_metadata, search_metadata, base_output_dir, special_identifier, ig_metadata, template_path)
        super(group_metadata, search_metadata, base_output_dir, ig_metadata)
        self.special_identifier = special_identifier
        self.template_path = template_path
      end

      def optional?
        true
      end

      def search_properties
        {}.tap do |properties|
          properties[:resource_type] = "'#{resource_type}'"
          properties[:search_param_names] = search_param_names_array
          properties[:token_search_params] = token_search_params_string if token_search_params.present?
          properties[:target_identifier] = special_identifier.transform_keys(&:to_sym)
        end
      end

      def template
        @template ||= if template_path && File.exist?(template_path)
                        File.read(template_path)
                      else
                        raise "Template file not found at #{template_path}"
                      end
      end

      def template_file_name
        template_path
      end

      def title
        "Server returns valid results for #{resource_type} search by identifier (#{special_identifier['display']})"
      end

      def description
        <<~DESCRIPTION.gsub(/\n{3,}/, "\n\n")
          A server SHOULD support searching by
          #{search_param_name_string} (#{special_identifier['display']}) on the #{resource_type} resource. This test
          will pass if resources are returned and match the search criteria. If
          none are returned, the test is skipped.

          #{capability_statement_reference_string}
        DESCRIPTION
      end
    end
  end
end
