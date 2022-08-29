kube-setup:
	k3d cluster create -p "8081:80@loadbalancer" --registry-create local-registry:0.0.0.0:5001 bellum
	istioctl install --set profile=demo -y

proto:
	protoc -I$(shell pwd) --go_out=. --go-grpc_out=. api/api.proto
	protoc -I$(shell pwd) --js_out=import_style=commonjs:js --grpc-web_out=import_style=commonjs,mode=grpcwebtext:js api/api.proto

.PHONY: js
js:
	npx webpack js/index.js -o js/dist/main.js

docker-build:
	docker build --tag web-grpc-go:latest .
	docker tag web-grpc-go:latest localhost:5001/web-grpc-go:latest
	docker push localhost:5001/web-grpc-go:latest

app-deploy:
	kubectl apply -f deployment/app.yaml

istio-deploy:
	kubectl apply -f deployment/gateway.yaml
	kubectl apply -f deployment/virtualservice.yaml
	kubectl apply -f deployment/destination-rule.yaml
	kubectl apply -f deployment/filter.yaml