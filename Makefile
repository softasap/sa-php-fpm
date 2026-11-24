init:
	poetry install

vagrant-login:
	poetry run molecule login -s default

# Default libvirt-backed test (KVM/QEMU). Requires vagrant + vagrant-libvirt.
molecule-libvirt:
	MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) poetry run molecule test -s default

molecule-libvirt-converge:
	MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) poetry run molecule converge -s default

# EOL PHP families (5.6, 7.0-7.4, 8.0, 8.1) maintained by packages.sury.org.
molecule-legacy:
	MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) poetry run molecule test -s legacy

molecule-legacy-converge:
	MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) poetry run molecule converge -s legacy

molecule-docker:
	ansible-galaxy collection install community.docker
	MOLECULE_TEST_ROLE=$(notdir $(CURDIR)) poetry run molecule test -s docker

# Galaxy release automation. API key lives in the pass backend and is synced
# to the GitHub repo secret GALAXY_API_KEY (used by .github/workflows/release.yml).
galaxy-secret:
	pass show psst/softasap/ansible/galaxy_api_key | gh secret set GALAXY_API_KEY -R softasap/$(notdir $(CURDIR))

galaxy-secret-check:
	gh secret list -R softasap/$(notdir $(CURDIR)) | grep -q GALAXY_API_KEY && echo "GALAXY_API_KEY present" || (echo "GALAXY_API_KEY missing — run: make galaxy-secret"; exit 1)
