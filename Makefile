.PHONY: up bootstrap password ui status notifications-secret down
up:
	cd terraform && terraform init && terraform apply -auto-approve
bootstrap:
	kubectl apply -f argocd/root-app.yaml
password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
ui:
	kubectl -n argocd port-forward svc/argocd-server 8080:80
status:
	kubectl -n argocd get applications
notifications-secret:
	@read -p "Webhook URL for sync-failure alerts: " url; \
	kubectl -n argocd create secret generic argocd-notifications-secret \
	  --from-literal=ops-webhook-url="$$url" \
	  --dry-run=client -o yaml | kubectl apply -f -
down:
	cd terraform && terraform destroy -auto-approve
