GREEN := "\033[0;32m"
NC := "\033[0;0m"

LOG := @sh -c '\
	   printf ${GREEN}; \
	   echo -e "\n> $$1\n"; \
	   printf ${NC}' VALUE

NODE_ENV := development

generate:
	$(LOG) "Generating frontend types..."
	yarn graphql:codegen


lint:
	$(LOG) "Linting frontend..."
	@yarn lint


test:
	$(LOG) "Testing frontend..."
	@yarn test --ci --collect-coverage --verbose


build:
	$(LOG) "Building frontend..."
	@yarn build


run:
	$(LOG) "Starting frontend..."
	@yarn develop

