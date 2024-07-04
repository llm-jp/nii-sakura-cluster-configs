# Prometheus Server

This directory contains Prometheus server configuration docker files.

## Usage

```sh
cp .env.example .env
cp grafana/grafana.example.ini grafana/grafana.ini
cp alertmanager/config.example.yml alertmanager/config.yml
# [IMPORTANT]: After copying the files above, fill out the necessary information

# Install docker, https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
sudo ./docker_setup

# On Prometheus Server
sudo docker volume create metrics_data
sudo docker volume create grafana_data

# update prometheus config (including alerting rules)
curl -i -XPOST localhost:9090/-/reload
```

#### How to run docker

```sh
# On Prometheus Server
sudo docker compose -f docker-compose.server.yml up -d

# On Prometheus Target
sudo docker compose -f docker-compose.exporter.yml up -d

# Run both on server and target
sudo docker compose -f docker-compose.exporter.yml -f docker-compose.server.yml up -d

# Check prometheus data
sudo apt install tree # if not installed
sudo tree /var/lib/docker/volumes/metrics_data/\_data/data
```

#### **Trouble Shooting**

- If you have trouble with the permission of docker, check the following

```sh
# check the permission of the directory
ls -alh ${HOME}

chmod a+x ${HOME}
```

#### **Port numbers**

- node_exporter: 9100
- dcgm_exporter: 9400
- pcm_exporter: 9738
- prometheus: 9090
- alertmanager: 9093

## References

### Prometheus/Exporter

**DCGM**

- [Getting Started — NVIDIA DCGM Documentation latest documentation](https://docs.nvidia.com/datacenter/dcgm/latest/user-guide/getting-started.html#ubuntu-lts-and-debian)
- [NVIDIA/dcgm-exporter: NVIDIA GPU metrics exporter for Prometheus leveraging DCGM](https://github.com/NVIDIA/dcgm-exporter)

**pcm**

- [intel/pcm: Intel® Performance Counter Monitor (Intel® PCM)](https://github.com/intel/pcm?tab=readme-ov-file#downloading-pre-compiled-pcm-tools)
- io/docs/guides/node-exporter/#configuring-your-prometheus-instances)
- [pcm/doc/PCM-EXPORTER.md at master · intel/pcm](https://github.com/intel/pcm/blob/master/doc/PCM-EXPORTER.md)

**Node Exporter**

- [prometheus/node_exporter: Exporter for machine metrics](https://github.com/prometheus/node_exporter)
- [prometheus の node_exporter の監視項目と設定例 #Docker - Qiita](https://qiita.com/kanga/items/21acb042237f8a27f437)

**Prometheus**

- [Installation | Prometheus](https://prometheus.io/docs/prometheus/latest/installation/)
- [Prometheus の設定をリロードする - CLOVER🍀](https://kazuhira-r.hatenablog.com/entry/2019/02/09/224152)
- [Storage | Prometheus](https://prometheus.io/docs/prometheus/latest/storage/#operational-aspects)
- [Data model | Prometheus](https://prometheus.io/docs/concepts/data_model/)
- [Prometheus でのさまざまな監視データ取得法 | さくらのナレッジ](https://knowledge.sakura.ad.jp/12057/)

### Grafana Setup

- [NVIDIA DCGM Exporter Dashboard | Grafana Labs](https://grafana.com/grafana/dashboards/12239-nvidia-dcgm-exporter-dashboard/)
- [Node Exporter Full | Grafana Labs](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
- docker で動かすときは、docker の bridge network の gateway アドレスを示さないと値を表示することができないので注意。`172.17.0.3`みたいなアドレスを追加する必要があるので注意。
