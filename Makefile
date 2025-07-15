.PHONY: generate

TMP_DIR := tmp
OUT_DIR := $(TMP_DIR)/go
GOBIN := $(shell go env GOPATH)/bin

generate:
	@echo "Generating Go code..."
	@mkdir -p $(OUT_DIR)
	@protoc --proto_path=$(CURDIR) \
		--plugin=protoc-gen-go=$(GOBIN)/protoc-gen-go \
		--plugin=protoc-gen-go-grpc=$(GOBIN)/protoc-gen-go-grpc \
		--go_out=$(OUT_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative \
		*.proto
	@cd $(OUT_DIR) && go mod init github.com/EspressoSystems/timeboost-proto
	@cd $(OUT_DIR) && go mod tidy
	@echo "Code generation complete"

clean:
	@rm -rf $(TMP_DIR)