这里是分成两组、每组 4 个模式、每个模式跑 5 次的两个命令。

**第一组命令（基础和动态避障）：**
```bash
MODES="baseline,dynamic,dynamic_astar,dynamic_dstar" RUNS_PER_MODE=5 ./run_all_experiments.sh
```

**第二组命令（带有社交避障）：**
```bash
MODES="social,social_astar,social_smac,social_dstar" RUNS_PER_MODE=5 ./run_all_experiments.sh
```

你可以先在一个终端里跑第一条，等它全部完成之后，再跑第二条。这样可以有效减轻电脑长时间连续跑仿真的压力。