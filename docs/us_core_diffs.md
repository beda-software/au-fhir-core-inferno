# Documented differences between AU and US implementations

This document is being updated: some list items may be changed, some may be deleted, and new ones may be added.

Documented changes do not include:

1. Deleted files;
2. Renamed files;
3. Renamed content inside of files.

## 1/12
**File:** [generator.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator.rb)

### Adding the MDSummaryGenerator and using it in the generator workflow.

**Reason:** For the confluence users

**Detailed changes:**
1. [Insert generator into the generator pipeline at the end](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator.rb#L46)
2. [Add a method to run MDSummaryGenerator](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator.rb#L99)

## 2/12
**File:** [group_metadata_extractor.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb)
### Updated the "ALL_VERSION_CATEGORY_FIRST_PROFILES" constant

**Reason:** The update is explained by differences from the US core list of profiles, in which the primary search must be carried out through the category.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L98


### Added the "ALL_VERSION_PATIENT_FIRST_PROFILES" constant

**Reason:** This was added because there are profile sets whose generated metadata does not contain search constants. Therefore, in this case, the search for the patient will be the primary search in their test group.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L103
2. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L135
3. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L143

### Updated the "ALL_VERSION_ID_FIRST_PROFILES" constant

**Reason:** Added because there are no search constants and there is no direct link to the patient. In this case, you need to search by ID.

**Other notes:** Maybe it should work in another way: like a provenance test group. In these cases, we get data from other test groups and we don't need to get data directly in current test groups.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L108
2. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L126
3. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L145

### Updated the "ALL_VERSION_NAME_FIRST_PROFILES" constant
**Reason:** Added because the generated metadata lacks a search by ID, a direct link to the patient, and constants for searching by attributes.

**Other notes:** Maybe it should be removed because profiles with this requirement do not exist in the March release (previously it was a HealthcareService)

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L113
2. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L122
3. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L147

### Updated the profile method
**Reason:** The reason for adding this update is that there is a reference to a StructureDefinition in the profiles, which does not exist in IG.

**Other notes:** It appears that this patch is no longer required after the March release. The March release is missing a link to a non-existent profile. Required DELETE

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/group_metadata_extractor.rb#L174

## 3/12
**File:** [ig_loader.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/ig_loader.rb)

### Updated the load_ig method
**Reason:** The reason for updating this method was the lack of search parameters and StructureDefinition.

**Other notes:** Re-checking is required, there may be some set of problems: perhaps the attachment of resources is no longer required, perhaps some of the added resources are no longer required. DOUBLE CHECKING is required.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/ig_loader.rb#L53

## 4/12
**File:** [ig_metadata_extractor.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/ig_metadata_extractor.rb)

### Updated the add_metadata_from_resources method
**Reason:** The reason for updating this method was due to a problem with non-existent profiles. In addition, a compact method has been added.

**Other notes:** It is necessary to RE-CHECK the need to use the compact method.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/ig_metadata_extractor.rb#L63

## 5/12
**File:** [ig_resources.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/ig_resources.rb)

### Updated the search_param_by_resource_and_name method
**Reason:** The reason for updating this method was the problem that some search parameters were missing or there were more than 1 of them.

**Other notes:** Initially, the method was a fairly simple search. It now contains conditional statements and several additional methods. It seems to me that there is a method there that can simply be removed, because it is a method that calls another method. METHOD EDITING REQUIRED

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/ig_resources.rb#L93

## 6/12
**File:** [must_support_metadata_extractor.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb)

### Updated the handle_special_cases method by adding new remove_observation_method_attribute method
**Reason:** In some observation profiles method attribute should not exist as MS.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L335
2. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L375

### Updated the handle_special_cases method by adding new remove_observation_value_attribute method
**Reason:** In some observation profiles value attribute should not exist as MS.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L336
2. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L366
3. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L406

### Updated the handle_special_cases method by adding new remove_lipid_result_attributes method
**Reason:** For some unknown reason, in one survey profile in particular, a large number of attributes are labeled as MS, but this should not be the case.

**Other notes:** It is required, if possible, to IDENTIFY and CORRECT the problem of the appearance of a large number of attributes marked as MS.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L337
2. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/must_support_metadata_extractor.rb#L353

## 7/12
**File**: [must_support_test.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/must_support_test.rb)

### Updated the missing_extensions method
**Reason**: The reason for updating this method is that in the initial version, extensions were obtained only through the "extension" attribute. This update allows you to extract the extension from any part of the resource.

**Detailed changes**:
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/must_support_test.rb#L87

## 8/12
**File**: [naming.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/naming.rb)

### Updated naming constants
**Reason**: The reason for the update is to change links to profiles.

**Other notes:** You need to DOUBLE CHECK and find out how current the profiles and their names are.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/naming.rb#L4

## 9/12
**File**: [reference_resolution_test.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/reference_resolution_test.rb)

### Add a hardcoded profile with the version for the reference resolution
**Reason**: The reason was the lack of a profile on the terminology server of the same version as that used in the AU core.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/reference_resolution_test.rb#L162

## 10/12
**File**: [special_cases.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/special_cases.rb)

### Add RelatedPerson to constant called RESOURCES_TO_EXCLUDE
**Reason**: This constant stores a list of resources for which it is not necessary to create test groups. In this particular case, RelatedPerson is a dependency, but it is not contained in the AU Core, so tests are not created for it.

**Detailed changes**:
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/special_cases.rb#L8

## 11/12
**File**: [search_definition_metadata_extractor.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/search_definition_metadata_extractor.rb)

### full_paths method refactoring
**Reason**: I think now it's better to read

**Detailed changes**:
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/search_definition_metadata_extractor.rb#L44

### multiple_or_expectation method update
**Reason**: It should be present because many SDs lack the "multipleOr" attribute, which could lead to errors in the generator.

**Detailed changes**:
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/search_definition_metadata_extractor.rb#L172

### values method update
**Reason**: It was necessary to add the ability to work with patternCoding

**Other notes:** Need to REVIEW

**Detailed changes**:
1. https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/search_definition_metadata_extractor.rb#L182

## 12/12
**File**: [search_test.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/search_test.rb)

### run_provenance_revinclude_search_test method update

**Reason**: We need the ability to search for provenance, even though the existence of the resource is not required.

**Commit message:**
1. https://github.com/hl7au/au-fhir-core-inferno/commit/2077b3e9c16a3562add7d56640c506df00893154

## 13/13
**File**: [search_metadata_extractor.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/search_metadata_extractor.rb)

### basic_searches method update

**Reason**: Tests with search parameters with the expectation "may" should be generated too.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/74d586fc1ae5d73109371053f5a949bb9a34ebb2/lib/au_core_test_kit/generator/search_metadata_extractor.rb#L34

### combo_searches method update

**Reason**: Tests with combo search parameters with the expectation "may" should be generated too.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/74d586fc1ae5d73109371053f5a949bb9a34ebb2/lib/au_core_test_kit/generator/search_metadata_extractor.rb#L52

## 14/14

### Chained search test

**Files:**

* [chain_search_test_generator.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/chain_search_test_generator.rb)
* [templates/chain_search.rb.erb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/templates/chain_search.rb.erb)
* [chained_search_test.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/chained_search_test.rb)

**Reason:** Support chain search for identifiers. This feature was implemented from zero.

## 15/15

### Add conformance expectation prefix for all read/search tests

**Reason:** The US Core test kit doesn't create tests for MAY expectations. In this case, it is clear to the user that all required read/search tests have SHALL expectations, while those that are not necessary have SHOULD expectations.

For the AU Core, we decided to create tests for MAY expectations. In this case, it is unclear which expectations are SHOULD and which are MAY, because none of them are required. To provide more clarity for the user, we decided to use prefixes with the expectations.

**Detailed changes**
https://github.com/hl7au/au-fhir-core-inferno/commit/658cf26403088e6843e317d717dfd059953af0b3

## 16/16
### Update FHIR version test

**Issue:** https://github.com/hl7au/au-fhir-core-inferno/issues/95

**Reason:** This problem is related to the FHIR client. If there is no value in the CapabilityStatement, it defaults to R4. Additionally, the resource may not be a CapabilityStatement. We fixed this by adding a status check and verifying the resource type.

**Detailed changes**
https://github.com/hl7au/au-fhir-core-inferno/commit/2d3c7de2432e896c563308a91868f8f91f7bd577

## 17/17

### Update optional? method
**Issue:** https://github.com/hl7au/au-fhir-core-inferno/issues/47

**Reason:** The method optional? returns either true or false for read/search tests. In our case, it doesn't work correctly out of the box because it considers not only the expectations from the CapabilityStatement but also the must_support_or_mandatory data generated by the metadata generator.

We decided to use only the expectations.


**Detailed changes:**
https://github.com/hl7au/au-fhir-core-inferno/commit/f5d4d6b383324ee5af156646125cafcfa0963069

## 18/18

### Multiple OR search tests

**Files:**
* [multiple_or_search_test_generator.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/multiple_or_search_test_generator.rb)
* [templates/multiple_or_search.rb.erb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/templates/multiple_or_search.rb.erb)
* [search_test.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/9bbb183e80e26f1b3767bbdc562c89c1b65f2400/lib/au_core_test_kit/search_test.rb#L420)

**Reason:** Because the functionality for multiple *OR* searches is not implemented out of the box, we decided to implement it.

### Multiple AND search tests

**Files:**
* [multiple_and_search_test_generator.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/multiple_and_search_test_generator.rb)
* [templates/multiple_and_search.rb.erb](https://github.com/hl7au/au-fhir-core-inferno/blob/master/lib/au_core_test_kit/generator/templates/multiple_and_search.rb.erb)
* [search_test.rb](https://github.com/hl7au/au-fhir-core-inferno/blob/9bbb183e80e26f1b3767bbdc562c89c1b65f2400/lib/au_core_test_kit/search_test.rb#L420)

**Reason:** Because the functionality for multiple *AND* searches is not implemented out of the box, we decided to implement it.

## 19/19

### Use the read test as the first test for the Patient test group instead of the search.

**Issue:** https://github.com/hl7au/au-fhir-core-inferno/issues/163

**Reason:** The default implementation of the suite is patient-centric, requiring users to use patient IDs to retrieve patient-related data. Initially, patient data was retrieved by searching for the patient using the _id parameter. However, some FHIR server implementations do not support searching for patients by _id, but do support the read interaction. We decided to add the ability to use the read interaction instead of search for the initial patient retrieval. The test will still fail, but the data will be retrieved.

**Detailed changes:**
1. https://github.com/hl7au/au-fhir-core-inferno/blob/9bbb183e80e26f1b3767bbdc562c89c1b65f2400/lib/au_core_test_kit/search_test.rb#L902
2. https://github.com/hl7au/au-fhir-core-inferno/blob/9bbb183e80e26f1b3767bbdc562c89c1b65f2400/lib/au_core_test_kit/search_test.rb#L103