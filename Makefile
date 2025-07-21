OUT_DIR := go-generated
MODULE_PATH := github.com/EspressoSystems/timeboost-proto/go-generated
GOBIN := $(shell go env GOPATH)/bin

.PHONY: generate
generate:
	@echo "Generating Go code..."
	@if [ -z "$(wildcard *.proto)" ]; then echo "Error: No .proto files found"; exit 1; fi
	@rm -rf $(OUT_DIR)
	@mkdir -p $(OUT_DIR)
	@protoc	--proto_path=.	\
		--plugin=protoc-gen-go=$(GOBIN)/protoc-gen-go \
		--plugin=protoc-gen-go-grpc=$(GOBIN)/protoc-gen-go-grpc \
		--go_out=$(OUT_DIR) --go_opt=module=$(MODULE_PATH) \
		--go-grpc_out=$(OUT_DIR) --go-grpc_opt=module=$(MODULE_PATH) \
    	*.proto
	@cd $(OUT_DIR) && go mod init $(MODULE_PATH)
	@cd $(OUT_DIR) && go get google.golang.org/protobuf@latest
	@cd $(OUT_DIR) && go get google.golang.org/grpc@latest
	@cd $(OUT_DIR) && go mod tidy
	@echo "Code generation complete"