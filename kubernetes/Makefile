minikube:
	bash scripts/minikube.sh

init:
	wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update && sudo apt install vault
	curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo update
	sudo sysctl -w fs.inotify.max_user_instances=256 # fix:failed to create fsnotify watcher: too many open files

setup: minikube
	helm upgrade --install vault hashicorp/vault -f helm/vault.yaml --namespace vault --create-namespace
	kubectl --namespace vault rollout status deployment/vault-agent-injector
	kubectl apply -f applications/payments-database.yaml
	kubectl rollout status deployment/payments-database
	kubectl apply -f applications/payments-processor.yaml
	kubectl rollout status deployment/payments-processor
	bash scripts/setup.sh

java:
	kubectl apply -f applications/agent/payments-app.yaml
	kubectl rollout status deployment/payments-app

java-sigterm:
	kubectl apply -f applications/agent/payments-app-term.yaml
	kubectl rollout status deployment/payments-app

clean-cluster:
	kubectl delete --ignore-not-found -f applications/agent/
	kubectl delete --ignore-not-found -f applications/
	helm del vault --namespace vault
	kill -9 $(shell cat pidfile)
	rm -rf pidfile

clean-minikube:
	minikube delete

clean: clean-cluster clean-minikube
