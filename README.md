# nii-sakura-cluster-configs

## Content

- `benchmark/`: クラスタベンチマークのスクリプト・結果
- `monitoring/`: モニタリング環境 (prometheus + grafana) 構築用Ansibleスクリプト等
- `slurm/`: Slurm環境構築用Ansibleスクリプト等
- `misc/`: その他、雑多なスクリプト等

### `benchmark/`

- `nccl-tests/` 
  - [NVIDIA/nccl-tests](https://github.com/NVIDIA/nccl-tests)を利用したネットワークのベンチマーク
- `fio/`
  - [fio](https://fio.readthedocs.io/en/latest/fio_doc.html)を利用したストレージベンチマーク

### `monitoring/`

### `slurm/`

### `misc/`

- [`update-cudnn-modulefile.yml`](./misc/update-cudnn-modulefile.yml)
  - cuDNNに関するmodulefileの更新用スクリプト
  - Transformer Engineのビルドのため、`CUDNN_PATH`の環境変数の設定を追加する
