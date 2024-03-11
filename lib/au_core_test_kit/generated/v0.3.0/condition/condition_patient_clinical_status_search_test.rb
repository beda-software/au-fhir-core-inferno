require_relative '../../../search_test'
require_relative '../../../generator/group_metadata'

module AUCoreTestKit
  module AUCoreV030
    class ConditionPatientClinicalStatusSearchTest < Inferno::Test
      include AUCoreTestKit::SearchTest

      title 'Server returns valid results for Condition search by patient + clinical-status'
      description %(
A server SHALL support searching by
patient + clinical-status on the Condition resource. This test
will pass if resources are returned and match the search criteria. If
none are returned, the test is skipped.

[AU Core Server CapabilityStatement](http://hl7.org/fhir/us/core//CapabilityStatement-us-core-server.html)

      )

      id :au_core_v030_condition_patient_clinical_status_search_test
      input :patient_ids,
        title: 'Patient IDs',
        description: 'Comma separated list of patient IDs that in sum contain all MUST SUPPORT elements',
        default: 'bennelong-anne, smith-emma, baby-smith-john, dan-harry, italia-sofia, wang-li'
  
      def self.properties
        @properties ||= SearchTestProperties.new(
          resource_type: 'Condition',
        search_param_names: ['patient', 'clinical-status'],
        token_search_params: ['clinical-status']
        )
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:condition_resources] ||= {}
      end

      run do
        run_search_test
      end
    end
  end
end