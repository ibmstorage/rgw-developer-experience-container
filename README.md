# IBM Ceph Object Storage Developer Edition with Object Browser

Here lies the containerfile for building the Object Storage Dev Edition.

## Building

```bash
podman build -t object-storage-dev-edition .
```

## Running

If you go with the default port mapping, then its quite easy as below

```bash
podman run -d \
  --name dev-edition \
  -p 8080:8081 \
  -p 9080:9080 \
  object-storage-dev-edition:latest
```

If you wish to change the default mapping then you need to provide the `ENDPOINT` as an env variable

```bash
podman run -d \
  --name dev-edition \
  -p 8080:8081 \
  -p 9500:9080 \
  -e ENDPOINT="http://127.0.0.1:9500" \
  object-storage-dev-edition:latest
```

Once its deployed, the UI will be visible on http://localhost:8080 or whichever port you mapped for the UI

## Debugging

```bash
podman logs dev-edition
```

will show you the logs and see what crashed when starting.
