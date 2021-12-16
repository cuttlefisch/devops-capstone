GREEN := "\033[0;32m"
NC := "\033[0;0m"

LOG := @sh -c '\
	   printf ${GREEN}; \
	   echo -e "\n> $$1\n"; \
	   printf ${NC}' VALUE

VERSION ?= 0.1.0

.PHONY: dist

generate:
	$(LOG) "Regenerating from schema..."
	@go run github.com/99designs/gqlgen generate


dependencies:
	$(LOG) "Running dependencies..."
	@docker-compose up -d


build:
	$(LOG) "Building backend..."
	@go build ./...



dist:
	$(LOG) "Building backend with version ${VERSION}..."
	@CGO_ENABLED=0 \
	  GOOS=linux \
	  go build -o dist/todo -ldflags="-X main.version=${VERSION}" .
	@cp todo.service dist/todo.service


test: test-acceptance test-unit

test-unit:
	$(LOG) "Running backend unit tests.."
	@go test -v ./...

test-acceptance:
	$(LOG) "Running acceptance tests"
	@go test -v -race -tags=acceptance ./testing/acceptance/...


run:
	$(LOG) "Running backend..."
	@go run server.go

