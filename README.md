# build
```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t your-image-name:tag \
  --push .
```
