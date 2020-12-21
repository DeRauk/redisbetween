.PHONY: build docker test lint

build:
	go build -o bin/redisbetween .

docker:
	docker-compose up

test:
	go test -count 1 -race ./...

lint:
	GOGC=75 golangci-lint run --timeout 10m --concurrency 32 -v -E golint ./...

ruby-test: build
	bin/redisbetween -unlink -network unix redis://127.0.0.1:7000?label=cluster redis://127.0.0.1:7006?label=standalone & cd ruby; rake; kill "$$!"

ruby-setup:
	cd ruby; bin/setup
