GO_OUT_DIR := go-generated
GO_MODULE_PATH := github.com/EspressoSystems/timeboost-proto/go-generated
GOBIN  := $(shell go env GOPATH)/bin
PROTOS := protos

.PHONY: generate-go generate-rust

generate-go:
	@echo "Generating Go code..."
	@rm -rf $(GO_OUT_DIR)
	@mkdir -p $(GO_OUT_DIR)
	@protoc	--proto_path=$(PROTOS) \
		--plugin=protoc-gen-go=$(GOBIN)/protoc-gen-go \
		--plugin=protoc-gen-go-grpc=$(GOBIN)/protoc-gen-go-grpc \
		--go_out=$(GO_OUT_DIR) --go_opt=module=$(GO_MODULE_PATH) \
		--go-grpc_out=$(GO_OUT_DIR) --go-grpc_opt=module=$(GO_MODULE_PATH) \
		$(PROTOS)/*.proto
	@cd $(GO_OUT_DIR) && go mod init $(GO_MODULE_PATH)
	@cd $(GO_OUT_DIR) && go get google.golang.org/protobuf@latest
	@cd $(GO_OUT_DIR) && go get google.golang.org/grpc@latest
	@cd $(GO_OUT_DIR) && go mod tidy
	@echo "Code generation complete"

generate-rust:
	cd rust && \
	cargo run --release --bin builder -- ../$(PROTOS)/ timeboost-proto/src/ && \
	cargo check
