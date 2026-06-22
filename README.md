# Esports Videos — Fullstack

Orchestrator repository for [esports-videos.com](https://www.esports-videos.com).

It brings the **API** and the **website (front)** together in a single Docker
environment so you can run the whole stack locally with one command. Each
project keeps its own repository so it can also be worked on in isolation:

| Project | Repository                                                          |
|---------|---------------------------------------------------------------------|
| API     | [`esportsvideos/api`](https://github.com/esportsvideos/api)         |
| Front   | [`esportsvideos/website`](https://github.com/esportsvideos/website) |

This repo clones them into `./api` and `./front` (both git-ignored) and wires
them together through Docker Compose `include` and a Traefik reverse proxy.

💿 Prerequisites
---------------

- Docker + Docker Compose v2 (`include` support)
- Make
- SSH access to the GitHub repositories above
- Free port `80`

⚙️ Installation
---------------

```bash
make install
```

This will:

1. create `compose.override.yaml` from the dist file,
2. clone the `api` repository into `./api`,
3. pull the service images and start the containers,
4. install the API (network, dependencies, …).

> The `front` project is not wired in yet — only the API is managed for now.

🌐 URLs
-------

Routing is host-based through Traefik. Add the hosts to `/etc/hosts` if your
resolver does not handle `*.localhost` automatically:

| Service           | URL                          |
|-------------------|------------------------------|
| Front             | http://www.esv.localhost/    |
| API               | http://www.esv.localhost/api |
| Adminer (db)      | http://adminer.esv.localhost |
| Traefik dashboard | http://traefik.esv.localhost |

🛠️ Common commands
------------------

Run `make help` for the full list. Most used:

| Command            | Description                                              |
|--------------------|----------------------------------------------------------|
| `make start`       | Start all containers                                     |
| `make start-all`   | Start containers from all profiles (incl. tools)         |
| `make stop`        | Stop all containers                                      |
| `make down`        | Stop and remove containers + networks                    |
| `make down-clean`  | **Destructive** — also removes volumes and `api`/`front` |
| `make pull`        | Pull service images                                      |
| `make api-sh`      | Open a shell in the PHP container                        |
| `make api-logs`    | Follow the PHP container logs                            |
| `make api-install` | Run the API install target                               |

API-specific targets (lint, phpstan, cs-fixer, composer, …) live in the API
repo's own `Makefile` — run them from `./api` or via `make api-sh`.

🗂️ Layout
---------

```
.
├── api/                    # cloned from esportsvideos/api (git-ignored)
├── front/                  # cloned from esportsvideos/website (git-ignored)
├── compose.yaml            # Traefik + include of api/compose.yaml
├── compose.override.yaml   # local overrides (git-ignored)
└── Makefile                # orchestration entrypoint
```

📄 License
----------

This project is under the MIT license. See the complete
license [in the bundle](LICENSE)
