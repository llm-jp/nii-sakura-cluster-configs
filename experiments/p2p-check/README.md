# 再現方法

[0] 何のためのフォルダか

* Sakura 環境でノード間 GPU Direct 通信が一部の GPU間でしか出来ない問題の再現スクリプト
* 参考: https://drive.google.com/drive/folders/1hv4M0Zalq-3c9QDwxIiCDULkpdWi_iWV?usp=drive_link

[1] https://github.com/llm-jp/scripts を clone

https://github.com/llm-jp/scripts/tree/main/pretrain/installers/v3-megatron-sakura を読みながら

```
$ git clone git@github.com:llm-jp/scripts.git
$ cd scripts/pretrain/installers/v3-megatron-sakura/
$ sbatch install.sh  DIR      # <- インストールしたいディレクトリ
```

(ちなみにDIRが存在していると mkdir がエラーになるので存在していないことを確認してから)

とすると, CPU partitionにジョブを投げて, 時間をかけて torch 環境を全セットしてくれる.

なおapex のコンパイルに時間がかかり, 今回の通信の問題には必要がないので, 多分install.shの # install PyTorch より後は消してしまっても問題なさそう(未確認)

[2] 本レポを clone

```
$ git clone git@github.com:llm-jp/nii-sakura-cluster-configs.git
$ cd 
```

[3] DIR に nii-sakura-cluster-configs.git/experiments/p2p-check/p2p.{bat.sh,sh,py} をコピー

```
cd DIR
cp nii-sakura-cluster-configs.git/experiments/p2p-check/p2p.{bat.sh,sh,py} .
```

`p2p.bat.sh` 冒頭の #SBATCH の行でオプションを適切に設定

```
#SBATCH --job-name=p2p-test   <- 趣味(省略可)
#SBATCH --nodes=2             <- ノード数 (今回必要なのは2)
#SBATCH --ntasks-per-node=8   <- ノード内のプロセス数 (今回必要なのは8)
#SBATCH --gres=gpu:8          <- --ntasks-per-node と合わせる
#SBATCH --output=%x-%j.out    <- 趣味(省略可)
#SBATCH --error=%x-%j.out     <- 趣味(省略可)
#SBATCH --partition=gpu-debug <- gpu-debug もしくは gpu-small
```

実行 (ジョブ投入)

```
$ sbatch p2p.bat.sh SENDER RECEIVER
```

例

```
$ sbatch p2p.bat.sh 0 9
```

以下を適切に利用

```
$ squeue [-p gpu-small/gpu-debug]   # ジョブの状態
$ sinfo                             # ノードの状態
```

sinfo でノードの状態を見ると, ジョブが走り終わった後もしばらくノードに * がついた状態になってジョブが始まらないことがあるが数十秒待っていれば解消される.

[4] 観測されている現象

8 GPUs x 2 ノードで, ノード間をまたぐ通信(SENDERとRECEIVERのノードが違うケース, つまり片方が0〜7, もう片方が8〜15)の多くがエラーになる. 8離れているときは成功する. それ以外にも成功するケースがあるが詳細はノードによって違う可能性もあるかも.



