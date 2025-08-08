# frozen_string_literal: true

require 'inferno_suite_generator/extractors/must_support_metadata_extractor'

module InfernoSuiteGenerator
  class Generator
    class MustSupportDeleteExtractor < MustSupportMetadataExtractor
      def must_supports
        @must_supports = {
          extensions: must_support_extensions,
          slices: must_support_slices,
          elements: must_support_elements
        }

        remove_elements

        @must_supports
      end

      def must_support_remove_elements(profile_url)
        data_absent_reason_element = {
          "element_key": 'path',
          "condition": 'pattern_match?',
          "value": '(component(:[^.]+)?\\.)?dataAbsentReason'
        }
        start_with_component = {
          "element_key": 'path',
          "condition": 'start_with?',
          "value": 'component'
        }
        equal_method = {
          "element_key": 'path',
          "condition": 'equal',
          "value": 'method'
        }
        profiles_map = {
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-bodyweight' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-bloodpressure' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-bodyheight' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-bodytemp' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-heartrate' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-resprate' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-smokingstatus' => [
            data_absent_reason_element
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-waistcircum' => [
            data_absent_reason_element,
            start_with_component
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult-path' => [
            data_absent_reason_element,
            equal_method
          ],
          'http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult' => [
            data_absent_reason_element,
            equal_method
          ]
        }

        profiles_map[profile_url] || []
      end

      def remove_elements
        remove_elements_configs = must_support_remove_elements(profile.url)
        remove_elements_configs.each do |remove_elements_config|
          element_key = remove_elements_config[:element_key]
          condition = remove_elements_config[:condition]
          value = remove_elements_config[:value]

          @must_supports[:elements].delete_if do |element|
            case condition
            when 'equal'
              element[element_key.to_sym] == value
            when 'start_with?'
              element[element_key.to_sym].start_with?(value)
            when 'pattern_match?'
              pattern = Regexp.new(value)
              pattern.match?(element[element_key.to_sym])
            else
              # do nothing
            end
          end
        end
      end
    end
  end
end
