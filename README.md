# Etcdctl Web

Web interface to etcd. Most basic CRUD operations supported.

## Dependencies

* Ruby >= 1.9.3 (I think)
* Bundler

## Quickstart

```
git clone https://github.com/cjbottaro/etcdctl-web.git
cd etcdctl-web
# Edit config/etcd.yml to point to your etcd cluster
bundle
rails s
```
## Docker (maybe quicker than quickstart)

```
docker run --rm -e ETCD_HOST=192.168.99.100:2379 cjbottaro/etcdctl-web:latest
```

`ETCD_HOST` should point to your Etcd endpoint.

By default, it starts the web server listening on `localhost:3000` and docker exposes `3000`.

Maybe not what you want, so that can be overridden with a command like:

```
docker run --rm -e ETCD_HOST=192.168.99.100:2379 -p 3001:3001 cjbottaro/etcdctl-web:latest rails s -b 0.0.0.0 -p 3001
```

Now the web server is running on `0.0.0.0:3001` and docker is exposing `3001->3001`.
