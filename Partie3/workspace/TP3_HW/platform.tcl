# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\UserTP\Desktop\FPGA1-main\Partie3\workspace\TP3_HW\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\UserTP\Desktop\FPGA1-main\Partie3\workspace\TP3_HW\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {TP3_HW}\
-hw {C:\Users\UserTP\Desktop\FPGA1-main\Partie 2\project_2\TP3_wrapper.xsa}\
-proc {microblaze_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {C:/Users/UserTP/Desktop/FPGA1-main/Partie3/workspace}

platform write
platform generate -domains 
platform active {TP3_HW}
platform generate
