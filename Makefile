.PHONY: generate

OUT_DIR := generated
MODULE_PATH := github.com/EspressoSystems/timeboost-proto
GOBIN := $(shell go env GOPATH)/bin

generate:
	@echo "Generating Go code..."
	@if [ -z "$(wildcard *.proto)" ]; then echo "Error: No .proto files found in protos/"; exit 1; fi
	@rm -rf $(OUT_DIR)
	@mkdir -p $(OUT_DIR)
	@protoc	--proto_path=protos	\
		--plugin=protoc-gen-go=$(GOBIN)/protoc-gen-go \
		--plugin=protoc-gen-go-grpc=$(GOBIN)/protoc-gen-go-grpc \
		--go_out=$(OUT_DIR) --go_opt=module=$(MODULE_PATH) \
		--go-grpc_out=$(OUT_DIR) --go-grpc_opt=module=$(MODULE_PATH) \
    	*.proto
	@echo "Code generation complete"