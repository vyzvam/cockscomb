# ACR Notes

```c#
docker run -it hello-world
docker login baasregistry.azurecr.io
docker tag hello-world baasregistry.azurecr.io/hello-world
docker push baasregistry.azurecr.io/hello-world
docker pull baasregistry.azurecr.io/hello-world


az acr login --name baasregistry
docker login baasregistry.azurecr.io


docker pull mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
docker tag mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine baasregistry.azurecr.io/samples/nginx
docker push baasregistry.azurecr.io/samples/nginx
```
