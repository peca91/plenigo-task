.PHONY: deps lint

deps:
	ansible-galaxy install -r roles/requirements.yml

lint:
	yamllint .
