# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home/yuva/workspace/TP2_SW_exo2_system/_ide/scripts/debugger_tp2_sw_exo2-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source /home/yuva/workspace/TP2_SW_exo2_system/_ide/scripts/debugger_tp2_sw_exo2-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Basys3 210183B164ADA" && level==0 && jtag_device_ctx=="jsn-Basys3-210183B164ADA-0362d093-0"}
fpga -file /home/yuva/workspace/TP2_SW_exo2/_ide/bitstream/TP2_wrapper.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw /home/yuva/workspace/TP2_HW2/export/TP2_HW2/hw/TP2_wrapper.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow /home/yuva/workspace/TP2_SW_exo2/Debug/TP2_SW_exo2.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
