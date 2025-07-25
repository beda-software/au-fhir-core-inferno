# frozen_string_literal: true

require_relative 'diagnosticresult/diagnosticresult_patient_code_search_test'
require_relative 'diagnosticresult/diagnosticresult_category_search_test'
require_relative 'diagnosticresult/diagnosticresult_code_search_test'
require_relative 'diagnosticresult/diagnosticresult_date_search_test'
require_relative 'diagnosticresult/diagnosticresult_status_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_category_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_category_date_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_category_status_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_code_date_search_test'
require_relative 'diagnosticresult/diagnosticresult_code_multiple_or_search_test'
require_relative 'diagnosticresult/diagnosticresult_status_multiple_or_search_test'
require_relative 'diagnosticresult/diagnosticresult_date_multiple_and_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_chain_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_ihi_chain_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_medicare_chain_search_test'
require_relative 'diagnosticresult/diagnosticresult_patient_dva_chain_search_test'
require_relative 'diagnosticresult/diagnosticresult_read_test'
require_relative 'diagnosticresult/diagnosticresult_validation_test'
require_relative 'diagnosticresult/diagnosticresult_must_support_test'
require_relative 'diagnosticresult/diagnosticresult_reference_resolution_test'

module AUCoreTestKit
  module AUCoreV200_DRAFT
    class DiagnosticresultGroup < Inferno::TestGroup
      title 'Observation Diagnostic Result Tests'
      short_description 'Verify support for the server capabilities required by the AU Core Diagnostic Result Observation.'
      description %(
  # Background

The AU Core Observation Diagnostic Result sequence verifies that the system under test is
able to provide correct responses for Observation queries. These queries
must contain resources conforming to the AU Core Diagnostic Result Observation as
specified in the AU Core v2.0.0-draft Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:

* patient + code
* patient + category
* patient + category + date

### Search Parameters
The first search uses the selected patient(s) from the prior launch sequence. Any subsequent searches will look for its parameter values from the results of the first search. For example, the `identifier` search in the patient sequence is performed by looking for an existing `Patient.identifier` from any of the resources returned in the `_id` search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
Observation resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Patient search for `gender=male` returns a `female`
patient.


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the Observation resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [AU Core Diagnostic Result Observation](http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :au_core_v200_draft_diagnosticresult
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'diagnosticresult', 'metadata.yml'), aliases: true))
      end

      test from: :au_core_v200_draft_diagnosticresult_patient_code_search_test
      test from: :au_core_v200_draft_diagnosticresult_category_search_test
      test from: :au_core_v200_draft_diagnosticresult_code_search_test
      test from: :au_core_v200_draft_diagnosticresult_date_search_test
      test from: :au_core_v200_draft_diagnosticresult_status_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_category_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_category_date_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_category_status_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_code_date_search_test
      test from: :au_core_v200_draft_diagnosticresult_code_multiple_or_search_test
      test from: :au_core_v200_draft_diagnosticresult_status_multiple_or_search_test
      test from: :au_core_v200_draft_diagnosticresult_date_multiple_and_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_chain_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_ihi_chain_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_medicare_chain_search_test
      test from: :au_core_v200_draft_diagnosticresult_patient_dva_chain_search_test
      test from: :au_core_v200_draft_diagnosticresult_read_test
      test from: :au_core_v200_draft_diagnosticresult_validation_test
      test from: :au_core_v200_draft_diagnosticresult_must_support_test
      test from: :au_core_v200_draft_diagnosticresult_reference_resolution_test
    end
  end
end
