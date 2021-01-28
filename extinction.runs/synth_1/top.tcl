# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.runs/synth_1/top.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 1
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7k325tffg900-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.cache/wt [current_project]
set_property parent.project_path C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part xilinx.com:kc705:part0:1.6 [current_project]
set_property ip_output_repo c:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
add_files -quiet C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.runs/ila_0_synth_1/ila_0.dcp
set_property used_in_implementation false [get_files C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.runs/ila_0_synth_1/ila_0.dcp]
add_files -quiet C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.runs/fifo_generator_1_synth_1/fifo_generator_1.dcp
set_property used_in_implementation false [get_files C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.runs/fifo_generator_1_synth_1/fifo_generator_1.dcp]
read_verilog -library xil_defaultlib {
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/AT93C46_IIC.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/BRAM128_9B9B.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/DATA_SEND_MCS.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/GET_SPILLINFO.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/IIC_CORE.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/IIC_CTL.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/LOC_REG.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/PCA9548_SW.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/PREPROCESSOR.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/SHIFT_COUNTER.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/SiTCP_XC7K_32K_BBT_V110.V
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/TIMER.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/WRAP_SiTCP_GMII_XC7K_32K.V
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/from_other_repo/kc705sitcp.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/top_mcs.v
  C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/top.v
}
read_ip -quiet C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/ila_0/ila_0.xci

read_ip -quiet C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1.xci

read_ip -quiet C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/bram_2byte_2K/bram_2byte_2K.xci
set_property used_in_implementation false [get_files -all c:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/bram_2byte_2K/bram_2byte_2K_ooc.xdc]

read_ip -quiet C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/shift_ram_hit/shift_ram_hit.xci
set_property used_in_implementation false [get_files -all c:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/shift_ram_hit/shift_ram_hit_ooc.xdc]

read_edif C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/SiTCP_XC7K_32K_BBT_V110.ngc
OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/SiTCP.xdc
set_property used_in_implementation false [get_files C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/SiTCP_Sample_Code_for_KC705_GMII/SiTCP.xdc]

read_xdc C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/kc705fmc.xdc
set_property used_in_implementation false [get_files C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/new/kc705fmc.xdc]

read_xdc C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/from_other_repo/SiTCP.xdc
set_property used_in_implementation false [get_files C:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/from_other_repo/SiTCP.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top top -part xc7k325tffg900-2
OPTRACE "synth_design" END { }


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
