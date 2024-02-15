transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib BASICLOGIC
vmap BASICLOGIC BASICLOGIC
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/custom_types.vhd}
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/Muxer.vhd}
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/Demuxer.vhd}
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/Encoder.vhd}
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/Decoder.vhd}
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/FAdder.vhd}
vcom -2008 -work BASICLOGIC {C:/Users/elpri/Desktop/ArchProject/D_FF.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/RCAdder.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/CSAdder.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/Reg.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/Counter.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/RegFile.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/ALU.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/ControlUnit.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/FStage.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/DStage.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/EStage.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/MStage.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/WBStage.vhd}
vcom -2008 -work work {C:/Users/elpri/Desktop/ArchProject/Pipeline.vhd}

