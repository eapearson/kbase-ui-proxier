# KBase User Interface Proxy Helper

A small docker image to provide an http/https reverse proxy for the KBase deployment environments. It is used for local development and testing of kbase-ui, narrative, and services.

## Using it

The one line wonder, which builds the proxy and starts it with the dev configuration:

```bash
make env=dev
```

In steps this is:

```bash
make docker-image
make run-docker-image env=dev
```

## Using with local narrative

```
local_narrative=true make run-docker-image env=dev
```

## Using with local dynamic services

```
dynamic_service_proxies="UIService" make run-docker-image env=dev
```

## Both together 

```
dynamic_service_proxies="UIService" local_narrative=true make run-docker-image env=dev
```

## Notes

Requires that at least one container already be running on the network "kbase