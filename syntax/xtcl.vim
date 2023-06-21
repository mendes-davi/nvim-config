" Vim syntax file
" Language:     Vivado TCL Commands
" Author:       Amal Khailtash <amal.khailtash@gmail.com>
" Maintainer:   Amal Khailtash <amal.khailtash@gmail.com>
" Last Change:  Tue, Oct 09, 2012  7:46:15 PM
" Version:      1.0
" Revision Comments:
"   Amal Khailtash <amal.khailtash@gmail.com> - Tue, Oct 09, 2012  7:46:15 PM
"     1.0 - Initial revision (based on Vivado 2013.1)

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Read the TCL syntax to start with
runtime! syntax/tcl.vim

" ----------------------------------------------------------------------------------------------------------------------
" Vivado TCL Commands
" ----------------------------------------------------------------------------------------------------------------------
" Board
syntax keyword xtclCommand      current_board get_board_interfaces get_board_pins
" ChipScope
syntax keyword xtclCommand      launch_chipscope_analyzer launch_impact write_chipscope_cdc
" DRC
syntax keyword xtclCommand      add_drc_checks create_drc_check create_drc_ruledeck create_drc_violation
syntax keyword xtclCommand      delete_drc_check delete_drc_ruledeck get_drc_checks get_drc_ruledecks get_drc_vios
syntax keyword xtclCommand      remove_drc_checks report_drc reset_drc reset_drc_check
" FileIO
syntax keyword xtclCommand      config_webtalk infer_diff_pairs pr_verify read_checkpoint read_csv read_edif read_ip
syntax keyword xtclCommand      read_saif read_twx read_vcd read_verilog read_vhdl read_xdc write_bitstream write_bmm
syntax keyword xtclCommand      write_checkpoint write_chipscope_cdc write_csv write_debug_probes write_edif write_ibis
syntax keyword xtclCommand      write_sdf write_verilog write_vhdl write_xdc
" Floorplan
syntax keyword xtclCommand      add_cells_to_pblock create_pblock delete_pblock delete_rpm get_pblocks place_cell
syntax keyword xtclCommand      place_pblocks remove_cells_from_pblock reset_ucf resize_pblock swap_locs unplace_cell
" GUIControl
syntax keyword xtclCommand      endgroup get_selected_objects highlight_objects mark_objects redo select_objects
syntax keyword xtclCommand      show_objects show_schematic start_gui startgroup stop_gui undo unhighlight_objects
syntax keyword xtclCommand      unmark_objects unselect_objects
" Hardware
syntax keyword xtclCommand      close_hw close_hw_target commit_hw_sio commit_hw_vio connect_hw_server
syntax keyword xtclCommand      create_hw_sio_link create_hw_sio_linkgroup create_hw_sio_scan current_hw_device
syntax keyword xtclCommand      current_hw_ila current_hw_ila_data current_hw_server current_hw_target
syntax keyword xtclCommand      disconnect_hw_server display_hw_ila_data display_hw_sio_scan get_hw_devices
syntax keyword xtclCommand      get_hw_ila_datas get_hw_ilas get_hw_probes get_hw_servers get_hw_sio_commons
syntax keyword xtclCommand      get_hw_sio_gtgroups get_hw_sio_gts get_hw_sio_iberts get_hw_sio_linkgroups
syntax keyword xtclCommand      get_hw_sio_links get_hw_sio_plls get_hw_sio_rxs get_hw_sio_scans get_hw_sio_txs
syntax keyword xtclCommand      get_hw_targets get_hw_vios open_hw open_hw_target program_hw_devices read_hw_ila_data
syntax keyword xtclCommand      read_hw_sio_scan refresh_hw_device refresh_hw_server refresh_hw_sio refresh_hw_target
syntax keyword xtclCommand      refresh_hw_vio remove_hw_sio_link remove_hw_sio_linkgroup remove_hw_sio_scan
syntax keyword xtclCommand      reset_hw_ila reset_hw_vio_activity reset_hw_vio_outputs run_hw_ila run_hw_sio_scan
syntax keyword xtclCommand      stop_hw_sio_scan upload_hw_ila_data wait_on_hw_ila wait_on_hw_sio_scan write_hw_ila_data
syntax keyword xtclCommand      write_hw_sio_scan
" IPFlow
syntax keyword xtclCommand      convert_ip copy_ip create_ip generate_target get_ipdefs get_ips import_ip
syntax keyword xtclCommand      open_example_project read_ip report_ip_status reset_target update_ip_catalog upgrade_ip
syntax keyword xtclCommand      validate_ip
" IPIntegrator
syntax keyword xtclCommand      apply_bd_automation assign_bd_address close_bd_design connect_bd_intf_net connect_bd_net
syntax keyword xtclCommand      copy_bd_objs create_bd_addr_seg create_bd_cell create_bd_design create_bd_intf_net
syntax keyword xtclCommand      create_bd_intf_pin create_bd_intf_port create_bd_net create_bd_pin create_bd_port
syntax keyword xtclCommand      current_bd_design current_bd_instance delete_bd_objs disconnect_bd_intf_net
syntax keyword xtclCommand      disconnect_bd_net find_bd_objs generate_target get_bd_addr_segs get_bd_addr_spaces
syntax keyword xtclCommand      get_bd_cells get_bd_designs get_bd_intf_nets get_bd_intf_pins get_bd_intf_ports
syntax keyword xtclCommand      get_bd_nets get_bd_pins get_bd_ports group_bd_cells move_bd_cells open_bd_design
syntax keyword xtclCommand      regenerate_bd_layout save_bd_design ungroup_bd_cells validate_bd_design write_bd_tcl
" Netlist
syntax keyword xtclCommand      connect_net create_cell create_net create_pin disconnect_net get_net_delays remove_cell
syntax keyword xtclCommand      remove_net remove_pin rename_ref resize_net_bus resize_pin_bus tie_unused_pins
" Object
syntax keyword xtclCommand      add_drc_checks create_drc_check create_drc_ruledeck current_board delete_drc_check
syntax keyword xtclCommand      delete_drc_ruledeck filter get_bel_pins get_bels get_board_interfaces get_board_pins
syntax keyword xtclCommand      get_boards get_cells get_clock_regions get_clocks get_debug_cores get_debug_ports
syntax keyword xtclCommand      get_delays get_designs get_drc_checks get_drc_ruledecks get_drc_vios get_files
syntax keyword xtclCommand      get_filesets get_generated_clocks get_hw_devices get_hw_ila_datas get_hw_ilas
syntax keyword xtclCommand      get_hw_probes get_hw_servers get_hw_sio_commons get_hw_sio_gtgroups get_hw_sio_gts
syntax keyword xtclCommand      get_hw_sio_iberts get_hw_sio_linkgroups get_hw_sio_links get_hw_sio_plls get_hw_sio_rxs
syntax keyword xtclCommand      get_hw_sio_scans get_hw_sio_txs get_hw_targets get_hw_vios get_interfaces
syntax keyword xtclCommand      get_io_standards get_iobanks get_ipdefs get_ips get_lib_cells get_lib_pins get_libs
syntax keyword xtclCommand      get_macros get_net_delays get_nets get_nodes get_package_pins get_parts get_path_groups
syntax keyword xtclCommand      get_pblocks get_pins get_pips get_ports get_projects get_property get_runs
syntax keyword xtclCommand      get_selected_objects get_site_pins get_site_pips get_sites get_slrs get_tiles
syntax keyword xtclCommand      get_timing_arcs get_timing_paths get_wires list_property list_property_value
syntax keyword xtclCommand      remove_drc_checks report_property reset_drc_check reset_property set_property
" PinPlanning
syntax keyword xtclCommand      create_interface create_port delete_interface make_diff_pair_ports place_ports
syntax keyword xtclCommand      remove_port resize_port_bus set_package_pin_val split_diff_pair_ports
" Power
syntax keyword xtclCommand      delete_power_results power_opt_design read_saif read_vcd report_power report_power_opt
syntax keyword xtclCommand      reset_default_switching_activity reset_operating_conditions reset_switching_activity
syntax keyword xtclCommand      set_default_switching_activity set_operating_conditions set_power_opt
syntax keyword xtclCommand      set_switching_activity
" Project
syntax keyword xtclCommand      add_files archive_project close_design close_project copy_ip create_fileset
syntax keyword xtclCommand      create_project create_run current_board current_fileset current_project current_run
syntax keyword xtclCommand      delete_fileset delete_run find_top generate_target get_board_interfaces get_board_pins
syntax keyword xtclCommand      get_boards get_files get_filesets get_ips get_projects get_runs help import_files
syntax keyword xtclCommand      import_ip import_synplify import_xise import_xst launch_runs list_targets lock_design
syntax keyword xtclCommand      make_wrapper move_files open_example_project open_io_design open_project open_run
syntax keyword xtclCommand      refresh_design reimport_files remove_files reorder_files report_compile_order
syntax keyword xtclCommand      reset_project reset_run reset_target save_constraints save_constraints_as
syntax keyword xtclCommand      save_project_as set_speed_grade update_compile_order update_design update_files
syntax keyword xtclCommand      wait_on_run
" PropertyAndParameter
syntax keyword xtclCommand      create_property filter get_param get_property list_param list_property
syntax keyword xtclCommand      list_property_value report_param report_property reset_param reset_property set_param
syntax keyword xtclCommand      set_property
" Report
syntax keyword xtclCommand      check_timing create_drc_violation create_slack_histogram delete_clock_networks_results
syntax keyword xtclCommand      delete_timing_results delete_utilization_results get_msg_config get_msg_count
syntax keyword xtclCommand      get_msg_limit report_carry_chains report_clock_interaction report_clock_networks
syntax keyword xtclCommand      report_clock_utilization report_clocks report_config_timing report_control_sets
syntax keyword xtclCommand      report_datasheet report_debug_core report_default_switching_activity
syntax keyword xtclCommand      report_disable_timing report_drc report_environment report_exceptions
syntax keyword xtclCommand      report_high_fanout_nets report_incremental_reuse report_io report_operating_conditions
syntax keyword xtclCommand      report_param report_phys_opt report_power report_property report_pulse_width
syntax keyword xtclCommand      report_route_status report_sso report_ssn report_switching_activity report_timing
syntax keyword xtclCommand      report_timing_summary report_transformed_primitives report_utilization reset_drc
syntax keyword xtclCommand      reset_msg_config reset_msg_count reset_msg_limit reset_msg_severity reset_ssn reset_sso
syntax keyword xtclCommand      reset_timing set_msg_config set_msg_limit set_msg_severity version
" SDC
syntax keyword xtclCommand      all_clocks all_fanin all_fanout all_inputs all_outputs all_registers create_clock
syntax keyword xtclCommand      create_generated_clock current_design current_instance get_cells get_clocks
syntax keyword xtclCommand      get_hierarchy_separator get_nets get_pins get_ports get_timing_arcs get_timing_paths
syntax keyword xtclCommand      group_path report_operating_conditions reset_operating_conditions set_case_analysis
syntax keyword xtclCommand      set_clock_groups set_clock_latency set_clock_sense set_clock_uncertainty set_data_check
syntax keyword xtclCommand      set_disable_timing set_false_path set_hierarchy_separator set_input_delay set_load
syntax keyword xtclCommand      set_logic_dc set_logic_one set_logic_unconnected set_logic_zero set_max_delay
syntax keyword xtclCommand      set_max_time_borrow set_min_delay set_multicycle_path set_operating_conditions
syntax keyword xtclCommand      set_output_delay set_propagated_clock set_units
" Simulation
syntax keyword xtclCommand      add_bp add_condition add_files add_force checkpoint_vcd close_saif close_sim close_vcd
syntax keyword xtclCommand      compile_simlib create_fileset current_scope current_sim current_time data2mem
syntax keyword xtclCommand      delete_fileset describe flush_vcd get_objects get_scopes get_value import_files
syntax keyword xtclCommand      launch_modelsim launch_xsim limit_vcd log_saif log_vcd log_wave ltrace move_files
syntax keyword xtclCommand      open_saif open_vcd open_wave_database ptrace read_saif read_vcd remove_bps
syntax keyword xtclCommand      remove_conditions remove_files remove_forces report_bps report_conditions report_drivers
syntax keyword xtclCommand      report_objects report_scopes report_simlib_info report_values reset_simulation restart
syntax keyword xtclCommand      run set_value start_vcd step stop stop_vcd write_sdf write_verilog write_vhdl xsim
" SysGen
syntax keyword xtclCommand      create_sysgen make_wrapper
" Timing
syntax keyword xtclCommand      check_timing config_timing_analysis config_timing_corners delete_timing_results
syntax keyword xtclCommand      get_net_delays get_timing_arcs get_timing_paths report_config_timing
syntax keyword xtclCommand      report_disable_timing report_exceptions report_timing report_timing_summary reset_timing
syntax keyword xtclCommand      set_delay_model set_disable_timing update_timing
" ToolLaunch
syntax keyword xtclCommand      launch_chipscope_analyzer launch_impact launch_modelsim launch_sdk launch_xsim
" Tools
syntax keyword xtclCommand      link_design list_features load_features opt_design phys_opt_design place_design
syntax keyword xtclCommand      route_design synth_design
" Waveform
syntax keyword xtclCommand      add_wave add_wave_divider add_wave_group add_wave_marker add_wave_virtual_bus
syntax keyword xtclCommand      close_wave_config create_wave_config current_wave_config get_wave_configs
syntax keyword xtclCommand      open_wave_config save_wave_config
" XDC
syntax keyword xtclCommand      add_cells_to_pblock all_clocks all_cpus all_dsps all_fanin all_fanout all_ffs all_hsios
syntax keyword xtclCommand      all_inputs all_latches all_outputs all_rams all_registers create_clock
syntax keyword xtclCommand      create_generated_clock create_macro create_pblock current_design current_instance
syntax keyword xtclCommand      delete_macros delete_pblock filter get_cells get_clocks get_generated_clocks
syntax keyword xtclCommand      get_hierarchy_separator get_iobanks get_macros get_nets get_package_pins get_path_groups
syntax keyword xtclCommand      get_pblocks get_pins get_ports get_sites get_timing_arcs group_path
syntax keyword xtclCommand      remove_cells_from_pblock resize_pblock set_case_analysis set_clock_groups
syntax keyword xtclCommand      set_clock_latency set_clock_sense set_clock_uncertainty set_data_check
syntax keyword xtclCommand      set_default_switching_activity set_disable_timing set_external_delay set_false_path
syntax keyword xtclCommand      set_hierarchy_separator set_input_delay set_input_jitter set_load set_logic_dc
syntax keyword xtclCommand      set_logic_one set_logic_unconnected set_logic_zero set_max_delay set_max_time_borrow
syntax keyword xtclCommand      set_min_delay set_multicycle_path set_operating_conditions set_output_delay
syntax keyword xtclCommand      set_package_pin_val set_power_opt set_propagated_clock set_property
syntax keyword xtclCommand      set_switching_activity set_system_jitter set_units update_macro
" XPS
syntax keyword xtclCommand      create_xps export_hardware generate_target get_boards launch_sdk list_targets
syntax keyword xtclCommand      make_wrapper reset_target
" Debug
syntax keyword xtclCommand      connect_debug_port create_debug_core create_debug_port delete_debug_core
syntax keyword xtclCommand      delete_debug_port disconnect_debug_port implement_debug_core read_chipscope_cdc
syntax keyword xtclCommand      report_debug_core
" HLS
syntax keyword xtclCommand      set_top open_solution close_solution set_part csynth_design csim_design cosim_design 
syntax keyword xtclCommand      export_design config_interface config_export

" Unsupported
syntax keyword xtclUnsupported  create_violation delete_port manage_user_drc_rule register_drc_rule save_design
syntax keyword xtclUnsupported  save_design_as write_ncd

" ----------------------------------------------------------------------------------------------------------------------
" Constants
" ----------------------------------------------------------------------------------------------------------------------
syntax keyword xtclConstant     NO YES FALSE TRUE DISABLE ENABLE NONE BACKBONE SLOW FAST DONTCARE NORMAL HIGH IBUF IFD
syntax keyword xtclConstant     BOTH HALT CONTINUE CORRECT_AND_CONTINUE CORRECT_AND_HALT PRE_COMPUTED FIRST_READBACK
syntax keyword xtclConstant     DIFF_HSTL_I DIFF_HSTL_II DIFF_HSTL_II_18 DIFF_HSTL_II_DCI DIFF_HSTL_II_DCI_18
syntax keyword xtclConstant     DIFF_HSTL_II_T_DCI DIFF_HSTL_II_T_DCI_18 DIFF_HSTL_II__T_DCI DIFF_HSTL_I_18
syntax keyword xtclConstant     DIFF_HSTL_I_DCI DIFF_HSTL_I_DCI_18 DIFF_HSUL_12_DCI DIFF_SSTL12_DCI DIFF_SSTL12_T_DCI
syntax keyword xtclConstant     DIFF_SSTL135 DIFF_SSTL135_DCI DIFF_SSTL135_R DIFF_SSTL135_T_DCI DIFF_SSTL15
syntax keyword xtclConstant     DIFF_SSTL15_DCI DIFF_SSTL15_R DIFF_SSTL15_T_DCI DIFF_SSTL18_I DIFF_SSTL18_II
syntax keyword xtclConstant     DIFF_SSTL18_II_DCI DIFF_SSTL18_II_T_DCI DIFF_SSTL18_I_DCI HSLVDCI_15 HSLVDCI_18 HSTL_I
syntax keyword xtclConstant     HSTL_II HSTL_II_18 HSTL_II_DCI HSTL_II_DCI_18 HSTL_II_T_DCI HSTL_II_T_DCI_18 HSTL_I_18
syntax keyword xtclConstant     HSTL_I_DCI HSTL_I_DCI_18 HSUL_12_DCI LVCMOS12 LVCMOS18 LVCMOS25 LVDCI_15 LVDCI_18
syntax keyword xtclConstant     LVDCI_DV2_15 LVDCI_DV2_18 SSTL12_DCI SSTL12_T_DCI SSTL135 SSTL135_DCI SSTL135_R
syntax keyword xtclConstant     SSTL135_T_DCI SSTL15 SSTL15_DCI SSTL15_R SSTL15_T_DCI SSTL18_I SSTL18_II SSTL18_II_DCI
syntax keyword xtclConstant     SSTL18_II_T_DCI SSTL18_I_DCI
syntax keyword xtclConstant     TUNED_SPLIT UNTUNED_SPLIT_25 UNTUNED_SPLIT_40 UNTUNED_SPLIT_50 UNTUNED_SPLIT_60
syntax keyword xtclConstant     UNTINED_SPLIT_75 TUNED UNTUNED_25 UNTUNED_50 UNTUNED_75

" ----------------------------------------------------------------------------------------------------------------------
" Properties
" ----------------------------------------------------------------------------------------------------------------------
syntax keyword xtclProperty     ASYNC_REG BEL CLOCK_DEDICATED_ROUTE COMPATIBLE_CONFIG_MODES DCI_CASCADE DIFF_TERM
syntax keyword xtclProperty     DONT_TOUCH DRIVE HIODELAY_GROUP HLUTNM IN_TERM INTERNAL_VREF IOB IODELAY_GROUP IOSTANDARD
syntax keyword xtclProperty     KEEP_HIERARCHY KEEPER LOC LUTNM MARK_DEBUG OUT_TERM PACKAGE_PIN POST_CRC POST_CRC_ACTION
syntax keyword xtclProperty     POST_CRC_FREQ POST_CRC_INIT_FLAG POST_CRC_SOURCE PROHIBIT PULLDOWN PULLUP SLEW VCCAUX_IO

" ----------------------------------------------------------------------------------------------------------------------
" Command Flags
" ----------------------------------------------------------------------------------------------------------------------
syntax match   xtclFlag      "[[:space:]]-[[:alpha:]]*\>"

" ----------------------------------------------------------------------------------------------------------------------
" Define the default highlighting.
" ----------------------------------------------------------------------------------------------------------------------
highligh default link xtclCommand      Operator
highligh default link xtclUnsupported  WarningMsg
highligh default link xtclConstant     Constant
highligh default link xtclProperty     Type
highligh default link xtclFlags        Special

let b:current_syntax = "xtcl"

" vim: fileformat=unix tabstop=2 shiftwidth=2 expandtab
