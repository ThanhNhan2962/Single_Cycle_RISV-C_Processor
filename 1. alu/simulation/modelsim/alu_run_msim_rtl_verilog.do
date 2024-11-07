transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_add_sub.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_sll.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_slt.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_sltu.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_xor.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_srl.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_sra.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_or.sv}
vlog -sv -work work +incdir+C:/altera/13.0sp1/milestone2/00_src/1.\ alu {C:/altera/13.0sp1/milestone2/00_src/1. alu/alu_and.sv}

