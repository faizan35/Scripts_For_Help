# Nginx Namespace Deployment Steps:

1. **Create the "nginx" Namespace:**

   ```sh
   kubectl create namespace nginx
   ```

2. **Apply the Nginx Pod, Service, and Deployment YAMLs within the "nginx" Namespace:**

   ```sh
   kubectl apply -f nginx-pod.yaml -n nginx
   kubectl apply -f nginx-service.yaml -n nginx
   kubectl apply -f nginx-deployment.yaml -n nginx
   ```
