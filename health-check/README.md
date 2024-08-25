## health-check

### インストール

```bash
$ python3 -m venv venv
$ source ~/venv/bin/active
(venv) $ pip3 install ansible-runner
```

### 使い方

```bash
$ source ~/venv/bin/active
(venv)$ git clone git@github.com:llm-jp/nii-sakura-cluster-configs.git
(venv)$ cd nii-sakura-cluster-configs/health-check
(venv)$ ansible-runner run . -p health-check.yml
```

### ルールの追加方法

以下のファイルにルールを追加

```text
health-check/project/health-check.yml
```
