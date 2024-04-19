#!/bin/bash
kubectl apply -f mysecret.yml
kubectl apply -f mysql-pvc.yaml
kubectl apply -f mysql-deployment.yaml
MYSQL_IP=$(kubectl get svc mysqldeployment -o jsonpath='{.spec.clusterIP}')
kubectl create configmap mysql-configmap --from-literal=mysql-host="$MYSQL_IP" --dry-run=client -o yaml | kubectl apply -f -
sed -i "s/WORDPRESS_DB_HOST: .*/WORDPRESS_DB_HOST: mysql-configmap/" wordpress-deployment.yaml
kubectl apply -f wordpress-deployment.yaml
echo "WordPress deployment completed."