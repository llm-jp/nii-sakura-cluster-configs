# LLM-JP Sakura 環境でノード間 GPU Direct 通信が一部の GPU間でしか出来ない問題の再現スクリプト

# NCCLによるp2p test

## 参考

https://drive.google.com/drive/folders/1hv4M0Zalq-3c9QDwxIiCDULkpdWi_iWV?usp=drive_link

## 手順1 (torch環境構築スクリプト)

https://github.com/llm-jp/scripts を clone
https://github.com/llm-jp/scripts/tree/main/pretrain/installers/v3-megatron-sakura を読みながら

```sh
$ git clone git@github.com:llm-jp/scripts.git
$ cd scripts/pretrain/installers/v3-megatron-sakura/
$ sbatch install.sh TARGET_DIR      # <- インストールしたいディレクトリ
```

(ちなみにTARGET_DIRが存在していると mkdir がエラーになるので存在していないことを確認してから)

とすると, CPU partitionにジョブを投げて, 時間をかけて torch 環境を全セットしてくれる.

なおapex のコンパイルに時間がかかり, 今回の通信の問題には必要がないので, 多分install.shの # install PyTorch より後は消してしまっても問題なさそう(未確認)

## 手順2 (本レポを clone)

```sh
$ git clone git@github.com:llm-jp/nii-sakura-cluster-configs.git
```

TARGET_DIR に nii-sakura-cluster-configs.git/experiments/p2p-check/p2p.{bat.sh,sh,py} をコピー

```sh
cp nii-sakura-cluster-configs/experiments/p2p-check/p2p.{bat.sh,sh,py} TARGET_DIR/
```

## 実行

### 準備

`p2p.bat.sh` 冒頭の #SBATCH の行でオプションを適切に設定

```sh
#SBATCH --job-name=p2p-test   <- 趣味(省略可)
#SBATCH --nodes=2             <- ノード数 (今回必要なのは2)
#SBATCH --ntasks-per-node=8   <- ノード内のプロセス数 (今回必要なのは8)
#SBATCH --gres=gpu:8          <- --ntasks-per-node と合わせる
#SBATCH --output=%x-%j.out    <- 趣味(省略可)
#SBATCH --error=%x-%j.out     <- 趣味(省略可)
#SBATCH --partition=gpu-debug <- gpu-debug もしくは gpu-small
```

### ジョブ投入

```sh
$ cd /path/to/TARGET_DIR
$ sbatch p2p.bat.sh SENDER RECEIVER
```

例

```sh
$ sbatch p2p.bat.sh 0 9
```

以下を適切に利用

```sh
$ squeue [-p gpu-small/gpu-debug]   # ジョブの状態
$ sinfo                             # ノードの状態
```

sinfo でノードの状態を見ると, ジョブが走り終わった後もしばらくノードに * がついた状態になってジョブが始まらないことがあるが数十秒待っていれば解消される.

以下のスクリプトを利用すると、0~15のGPUの全ての組み合わせに関してテストを実行できる。

```bash
cp nii-sakura-cluster-configs/experiments/p2p-check/submit_p2p_tests.sh TARGET_DIR/
cd /path/to/TARGET_DIR/
./submit_p2p_tests.sh # 一つのペアの実行時間が40秒だとすると、40s * {16*16-16} = 9600s = 2h40mかかる
```

上で得られたテスト結果は以下のスクリプトで可視化できる。
```bash
cd /path/to/p2p-check
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

python3 p2p_nccl_matrix.py {TARGET_DIR}
```

## 観測されている現象

8 GPUs x 2 ノードで, ノード間をまたぐ通信(SENDERとRECEIVERのノードが違うケース, つまり片方が0〜7, もう片方が8〜15)の多くがエラーになる. 8離れているときは成功する. それ以外にも成功するケースがあるが詳細はノードによって違う可能性もあるかも.

# `ping`によるp2p test

## pingテスト

```bash
./p2p_ping_test.sh {a or b}
```

`./data/{a or b}_cluster_connectivty.csv`にテスト結果が保存される。

## pythonによる可視化

```bash
cd /path/to/p2p-check
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

python3 p2p_ping_test_heatmap.py
```

`img/cluster_{a or b}_connectivity_heatmap.png`にヒートマップ画像が保存される。
青が通信成功、赤が通信失敗を表す。
