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

### サンプル出力

```bash
(venv) [sora@login002 health-check]$ ansible-runner run . -p health-check.yml

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [a001]
ok: [a005]
ok: [a003]
ok: [a002]
...

TASK [Fail if any GPU ECC errors found in dmesg] *******************************
failed: [a055] (item=[Sun Aug 25 20:10:45 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:10:45 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
failed: [a055] (item=[Sun Aug 25 20:10:51 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:10:51 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
failed: [a055] (item=[Sun Aug 25 20:10:52 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:10:52 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
failed: [a055] (item=[Sun Aug 25 20:11:08 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:11:08 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
failed: [a055] (item=[Sun Aug 25 20:11:09 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:11:09 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
failed: [a055] (item=[Sun Aug 25 20:26:17 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:26:17 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
failed: [a055] (item=[Sun Aug 25 20:31:38 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0) => {"ansible_loop_var": "item", "changed": false, "item": "[Sun Aug 25 20:31:38 2024] NVRM: Xid (PCI:0000:2a:00): 140, pid='<unknown>', name=<unknown>, An uncorrectable ECC error detected (possible firmware handling failure) DRAM:0, LTC:0, MMU:0, PCIE:0", "msg": "GPU ECC errors found in dmesg"}
...

PLAY RECAP *********************************************************************
...
a055                       : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
...
```
