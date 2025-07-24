compose = docker compose
inferno = run inferno

.PHONY: setup generate summary new_release tests run pull build up stop down rubocop migrate clean_generated ig_download

setup: pull build migrate

generate:
	rm -rf lib/au_core_test_kit/generated/
	$(compose) $(inferno) bundle exec rake au_core:generate
	$(compose) $(inferno) rubocop -A lib/au_core_test_kit/
	$(compose) $(inferno) ruby lib/au_core_test_kit/generator/summary_generator.rb

generate_local:
	rm -rf lib/au_core_test_kit/generated/
	bundle exec rake au_core:generate
	rubocop -A lib/au_core_test_kit/

summary: build
	$(compose) $(inferno) ruby lib/au_core_test_kit/generator/summary_generator.rb

new_release: build ig_download generate summary

tests:
	$(compose) run -e APP_ENV=test inferno bundle exec rspec

run: build up

pull:
	$(compose) pull

build:
	$(compose) build

up:
	$(compose) up

stop:
	$(compose) stop

down:
	$(compose) down

rubocop:
	$(compose) $(inferno) rubocop

rubocop-fix:
	$(compose) $(inferno) rubocop -A

migrate:
	$(compose) $(inferno) bundle exec rake db:migrate

clean_generated:
	sudo rm -rf lib/au_core_test_kit/generated/
	git checkout lib/au_core_test_kit/generated/

ig_download:
	$(compose) $(inferno) ruby lib/au_core_test_kit/generator/ig_download.rb

full_develop_restart: stop down generate setup run

build_uploadfig:
	$(compose) -f compose.uploadfig.yaml build

download_ig_deps:
	@for tgz_file in lib/au_core_test_kit/igs/*.tgz; do \
		filename=$$(basename $$tgz_file .tgz); \
		echo "Processing $$tgz_file..."; \
		$(compose) -f compose.uploadfig.yaml run --rm uploadfig UploadFIG -t -s $$tgz_file --includeReferencedDependencies -of lib/au_core_test_kit/igs/$$filename-deps-bundle.json; \
	done

uploadfig_download_ig_deps:
	$(compose) -f compose.uploadfig.yaml run --rm uploadfig \
	  UploadFIG \
		-pid hl7.fhir.au.core \
		-pv 2.0.0-draft \
		-fd \
		-r "*" \
		--includeReferencedDependencies \
		-ap "hl7.fhir.r4.core|5.0.0" \
		-of lib/au_core_test_kit/igs/au-core-2.0.0-draft-deps-bundle.json \
		-t

download_ig:
	curl -L -o lib/au_core_test_kit/igs/hl7.fhir.au.core-2.0.0-draft.tgz https://packages.fhir.org/hl7.fhir.au.core/2.0.0-draft
	curl -L -o lib/au_core_test_kit/igs/csiro.fhir.au.smartforms-0.3.0.tgz https://packages.fhir.org/csiro.fhir.au.smartforms/0.3.0
