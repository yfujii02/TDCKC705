# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: /home/nakazawa/8-gev/kc705/SiTCP_Sample_Code_for_KC705_GMII/SiTCP.xdc

# XDC: /home/nakazawa/8-gev/kc705/firmware/extinction.srcs/sources_1/new/kc705fmc.xdc

# XDC: /home/nakazawa/8-gev/kc705/firmware/from_other_repo/SiTCP.xdc

# XDC: /home/nakazawa/8-gev/kc705/firmware/from_other_repo/kc705sitcp.xdc

# IP: ip/fifo_generator_1/fifo_generator_1.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==fifo_generator_1 || ORIG_REF_NAME==fifo_generator_1} -quiet] -quiet

# XDC: ip/fifo_generator_1/fifo_generator_1.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==fifo_generator_1 || ORIG_REF_NAME==fifo_generator_1} -quiet] {/U0 } ]/U0 ] -quiet] -quiet
