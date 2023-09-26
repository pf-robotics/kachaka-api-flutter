#!/bin/bash

mkdir -p kachaka_api_package
protoc --proto_path=kachaka-api/protos --dart_out=grpc:kachaka_api_package/lib/src kachaka-api/protos/kachaka-api.proto
