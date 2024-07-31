# nii-sakura-cluster-configs

## Content

- `benchmark/`: クラスタベンチマークのスクリプト・結果
- `monitoring/`: モニタリング環境 (prometheus + grafana) 構築用Ansibleスクリプト等
- `slurm/`: Slurm環境構築用Ansibleスクリプト等
- `cudnn/`: cuDNN modulefileの更新用スクリプト
- `nccl/`: NCCL modulefileの更新用スクリプト

### `benchmark/`

- `nccl-tests/` 
  - [NVIDIA/nccl-tests](https://github.com/NVIDIA/nccl-tests)を利用したネットワークのベンチマーク
- `fio/`
  - [fio](https://fio.readthedocs.io/en/latest/fio_doc.html)を利用したストレージベンチマーク

### `monitoring/`

### `slurm/`

### `cudnn/` and `nccl/`

- [`(cudnn|nccl)/update-modulefile.yml`](./misc/update-cudnn-modulefile.yml)
  - cuDNN/NCCLに関するmodulefileの更新用スクリプト
  - Transformer Engineのビルドのため、`CUDNN_PATH`などの環境変数の設定を追加する

#### cuDNN modulefile の変更内容

```console
$ module load cudnn/8.9.7 
$ printenv | grep -i cudnn
CUDNN_LIBRARY=/usr/local/cudnn/8.9.7/lib           # 追加
PWD=/home/llm-jp-admin/sosuke/nii-sakura-cluster-configs/cudnn
CUDNN_HOME=/usr/local/cudnn/8.9.7                  # 追加
MODULESHOME=/usr/local/cudnn/8.9.7
CUDNN_ROOT=/usr/local/cudnn/8.9.7                  # 追加
CUDNN_PATH=/usr/local/cudnn/8.9.7                  # 追加
__MODULES_LMCONFLICT=cudnn/8.9.7&cudnn
LIBRARY_PATH=/usr/local/cudnn/8.9.7/lib
LOADEDMODULES=cudnn/8.9.7
CUDNN_VERSION=8.9.7                                # 追加
CUDNN_INCLUDE_DIR=/usr/local/cudnn/8.9.7/include   # 追加
CUDNN_ROOT_DIR=/usr/local/cudnn/8.9.7              # 追加
LD_LIBRARY_PATH=/usr/local/cudnn/8.9.7/lib
CUDNN_LIBRARY_DIR=/usr/local/cudnn/8.9.7/lib       # 追加
_LMFILES_=/usr/local/modulefiles/cudnn/8.9.7
CPATH=/usr/local/cudnn/8.9.7/include
```

#### NCCL modulefile の変更内容

```console
$ module load nccl/2.22.3 
$ printenv | grep -i nccl
__MODULES_LMALTNAME=nccl/2.22.3&as|nccl/default&as|nccl/latest
PKG_CONFIG_PATH=/usr/local/nccl/2.22.3/lib/pkgconfig
NCCL_VERSION=2.22.3                      # 追加
MODULESHOME=/usr/local/nccl/2.22.3
NCCL_HOME=/usr/local/nccl/2.22.3
NCCL_ROOT=/usr/local/nccl/2.22.3         # 追加
__MODULES_LMCONFLICT=nccl/2.22.3&nccl
LIBRARY_PATH=/usr/local/nccl/2.22.3/lib
LOADEDMODULES=nccl/2.22.3
LD_LIBRARY_PATH=/usr/local/nccl/2.22.3/lib
_LMFILES_=/usr/local/modulefiles/nccl/2.22.3
CPATH=/usr/local/nccl/2.22.3/include
```

#### 更新の実行

```bash
cd cudnn # or nccl
ansible-playbook -i hosts.ini --timeout=120 update-modulefile.yml
```