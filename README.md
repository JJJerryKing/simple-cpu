# Simple CPU — Icarus Verilog 仿真版

## 项目简介

这是一个Verilog HDL学习项目，包括基础学习模块和一个32位简易CPU实现。本分支围绕 Icarus Verilog 构建轻量级仿真流程。

CPU 部分实现了 ARM 风格的数据处理指令，而不是完整的 ARM 处理器实现。

## 实现内容

| 编号 | 模块 | 主要内容 |
| --- | --- | --- |
| 0 | 基础学习模块 | 4 位全加器、带异步复位的 8 位 D 触发器 |
| 1 | 桶形移位器 | 32 位逻辑移位、算术移位、循环移位和进位输出 |
| 2 | ALU | 32 位逻辑运算、算术运算与 NZCV 标志生成 |
| 3 | 通用寄存器组 | 多读端口、写端口、PC 写入以及不同处理器模式下的分组寄存器 |
| 4 | 存储器 | 64 × 32 位 RAM、存储器读写控制和初始化数据 |
| 5 | CPU 数据处理通路 | 取指、条件判断、译码、寄存器读取、移位、ALU 运算和回写控制 |

## 目录结构

```text
simple-cpu/
├── rtl/
│   ├── 0/                       # 基础组合逻辑与时序逻辑
│   ├── 1-barrelShifter/         # 桶形移位器
│   ├── 2-ALU/                   # 算术逻辑单元
│   ├── 3-generalPurposeRF/      # 通用寄存器组
│   ├── 4-memory/                # RAM、存储器接口与初始化数据
│   └── 5-CPU(dataprocess)/      # CPU 数据处理通路及指令 ROM
└── tests/
    ├── 0/                       # 基础模块测试平台
    ├── 1-barrelShifter/         # 桶形移位器测试平台
    ├── 2-ALU/                   # ALU 测试平台
    ├── 3-generalPurposeRF/      # 寄存器组测试平台
    ├── 4-memory/                # 存储器测试平台
    ├── 5-CPU(dataprocess)/      # CPU 测试平台
    └── build/                   # 仿真构建产物与波形文件
```

## 环境要求

- Git
- Icarus Verilog 12.0 或兼容版本
- GTKWave（可选，用于查看波形）
- PowerShell

安装后可检查工具是否可用：

```powershell
git --version
iverilog -V
vvp -V
gtkwave --version
```

## 快速开始

获取 `iverilog` 分支并进入仓库根目录：

```powershell
git clone --branch iverilog --single-branch "https://github.com/JJJerryKing/simple-cpu.git"
cd simple-cpu
```

创建各测试使用的构建目录：

```powershell
$buildDirs = @(
    "tests/build/0",
    "tests/build/1-barrelShifter",
    "tests/build/2-ALU",
    "tests/build/3-generalPurposeRF",
    "tests/build/4-memory",
    "tests/build/5-CPU(dataprocess)"
)
New-Item -ItemType Directory -Force -Path $buildDirs | Out-Null
```

之后可以从下面选择一个模块进行编译和仿真。

## 各模块仿真命令

以下命令均在仓库根目录执行。

### 0. 基础模块

4 位全加器：

```powershell
iverilog -g2005 -s tb_adder_4bit -o "tests/build/0/adder_4bit.vvp" "rtl/0/adder_4bit.v" "tests/0/tb_adder_4bit.v"
vvp "tests/build/0/adder_4bit.vvp"
```

8 位 D 触发器：

```powershell
iverilog -g2005 -s tb_dff_8bit -o "tests/build/0/dff_8bit.vvp" "rtl/0/dff_8bit.v" "tests/0/tb_dff_8bit.v"
vvp "tests/build/0/dff_8bit.vvp"
```

### 1. 桶形移位器

`barrel_shifter`：

```powershell
iverilog -g2005 -s tb_barrel_shifter -o "tests/build/1-barrelShifter/barrel_shifter.vvp" "rtl/1-barrelShifter/barrel_shifter.v" "tests/1-barrelShifter/tb_barrel_shifter.v"
vvp "tests/build/1-barrelShifter/barrel_shifter.vvp"
```

`barrel_shifter_main`：

```powershell
iverilog -g2005 -s tb_barrel_shifter_main -o "tests/build/1-barrelShifter/barrel_shifter_main.vvp" "rtl/1-barrelShifter/barrel_shifter_main.v" "tests/1-barrelShifter/tb_barrel_shifter_main.v"
vvp "tests/build/1-barrelShifter/barrel_shifter_main.vvp"
```

### 2. 算术逻辑单元

```powershell
iverilog -g2005 -s tb_ALU -o "tests/build/2-ALU/ALU.vvp" "rtl/2-ALU/ALU.v" "tests/2-ALU/tb_ALU.v"
vvp "tests/build/2-ALU/ALU.vvp"
```

### 3. 通用寄存器组

```powershell
iverilog -g2005 -s tb_RF -o "tests/build/3-generalPurposeRF/General_Purpose_RF.vvp" "rtl/3-generalPurposeRF/General_Purpose_RF.v" "tests/3-generalPurposeRF/test_RF.v"
vvp "tests/build/3-generalPurposeRF/General_Purpose_RF.vvp"
```

### 4. 存储器

```powershell
iverilog -g2005 -s tb_memory -o "tests/build/4-memory/memory.vvp" "rtl/4-memory/RAM.v" "rtl/4-memory/memory.v" "tests/4-memory/test_memory.v"
vvp "tests/build/4-memory/memory.vvp"
```

### 5. CPU 数据处理通路

```powershell
iverilog -g2005 -s tb_CPU1 `
    -o 'tests/build/5-CPU(dataprocess)/cpu1.vvp' `
    'rtl/5-CPU(dataprocess)/barrel_shifter.v' `
    'rtl/5-CPU(dataprocess)/ALU.v' `
    'rtl/5-CPU(dataprocess)/ALU_shifter.v' `
    'rtl/5-CPU(dataprocess)/Controller.v' `
    'rtl/5-CPU(dataprocess)/General_Purpose_RF.v' `
    'rtl/5-CPU(dataprocess)/ROM.v' `
    'rtl/5-CPU(dataprocess)/LD.v' `
    'rtl/5-CPU(dataprocess)/CPU.v' `
    'tests/5-CPU(dataprocess)/tb_CPU1.v'

vvp 'tests/build/5-CPU(dataprocess)/cpu1.vvp'
```

## 查看波形

完成相应仿真后，可运行以下命令打开波形：

```powershell
gtkwave "tests/build/adder_4bit.vcd"
gtkwave "tests/build/dff_8bit.vcd"
gtkwave "tests/build/1-barrelShifter/barrel_shifter.vcd"
gtkwave "tests/build/1-barrelShifter/barrel_shifter_main.vcd"
gtkwave "tests/build/2-ALU/ALU.vcd"
gtkwave "tests/build/3-generalPurposeRF/RF.vcd"
gtkwave "tests/build/4-memory/memory.vcd"
gtkwave 'tests/build/5-CPU(dataprocess)/CPU1.vcd'
```

## 项目状态

当前分支已包含基础模块、CPU包括数据处理指令及对应测试平台，并能够使用 Icarus Verilog 完成编译。项目以课程学习和 RTL 仿真为主要用途，尚未覆盖完整指令系统、异常处理、流水线、缓存及外设接口。
