.PHONY: up bootstrap password ui down
up:
	cd terraform && terraform init && terraform apply -auto-approve
bootstrap:
	kubectl apply -f argocd/root-app.yaml
password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
ui:
	kubectl -n argocd port-forward svc/argocd-server 8080:80
down:
	cd terraform && terraform destroy -auto-approve
