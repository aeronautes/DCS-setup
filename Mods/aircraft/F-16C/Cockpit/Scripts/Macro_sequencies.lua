dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")

-- timeouts and delays
std_message_timeout = 15

local	t_start	= 0.0
local	t_stop	= 0.0
local	dt		= 0.2
local	dt_mto	= 0.5
local	start_sequence_time	= 210.0
local	stop_sequence_time	= 60.0

--
start_sequence_full 	  = {}
stop_sequence_full		  = {}
cockpit_illumination_full = {}

function push_command(sequence, run_t, command)
	sequence[#sequence + 1] =  command
	sequence[#sequence]["time"] = run_t
end

function push_start_command(delta_t, command)
	t_start = t_start + delta_t
	push_command(start_sequence_full,t_start, command)
end

function push_stop_command(delta_t, command)
	t_stop = t_stop + delta_t
	push_command(stop_sequence_full,t_stop, command)
end

function clear_mfd_page(mfd, osb)
	push_stop_command(dt, {device = mfd, action = osb, value = 1.0})
	push_stop_command(dt, {device = mfd, action = osb, value = 1.0})
	push_stop_command(dt, {device = mfd, action = mfd_commands.OSB_1, value = 1.0})
end

function press_rel(dev, button)
	push_stop_command(dt, {device = devices.UFC, 	action = button, value = 1.0})
	push_stop_command(dt, {device = devices.UFC, 	action = button, value = -1.0})
end

--
local count = 0
local function counter()
	count = count + 1
	return count
end

-- conditions
count = -1

F16_AD_NO_FAILURE				= counter()
F16_AD_ERROR					= counter()

F16_AD_THROTTLE_SET_TO_OFF		= counter()
F16_AD_THROTTLE_AT_OFF			= counter()
F16_AD_THROTTLE_SET_TO_IDLE		= counter()
F16_AD_THROTTLE_AT_IDLE			= counter()
F16_AD_THROTTLE_DOWN_TO_IDLE	= counter()

F16_AD_JFS_READY				= counter()
F16_AD_ENG_IDLE_RPM				= counter()
F16_AD_ENG_CHECK_IDLE			= counter()
F16_AD_JFS_VERIFY_OFF			= counter()

F16_AD_INS_CHECK_RDY			= counter()

F16_AD_LEFT_HDPT_CHECK_RDY		= counter()
F16_AD_RIGHT_HDPT_CHECK_RDY 	= counter()

F16_AD_HMCS_ALIGN				= counter()


--
alert_messages = {}

alert_messages[F16_AD_ERROR]					= { message = _("FM MODEL ERROR"),							message_timeout = std_message_timeout}

alert_messages[F16_AD_THROTTLE_SET_TO_OFF]		= { message = _("THROTTLE - TO OFF"),						message_timeout = std_message_timeout}
alert_messages[F16_AD_THROTTLE_AT_OFF]			= { message = _("THROTTLE MUST BE AT OFF"),					message_timeout = std_message_timeout}
alert_messages[F16_AD_THROTTLE_SET_TO_IDLE]		= { message = _("THROTTLE - TO IDLE"),						message_timeout = std_message_timeout}
alert_messages[F16_AD_THROTTLE_AT_IDLE]			= { message = _("THROTTLE MUST BE AT IDLE"),				message_timeout = std_message_timeout}
alert_messages[F16_AD_THROTTLE_DOWN_TO_IDLE]	= { message = _("THROTTLE - TO IDLE"),						message_timeout = std_message_timeout}

alert_messages[F16_AD_JFS_READY]				= { message = _("JFS RUN LIGHT MUST BE ON WITHIN 30 SEC"),	message_timeout = std_message_timeout}
alert_messages[F16_AD_ENG_IDLE_RPM]				= { message = _("ENGINE RPM FAILURE"),						message_timeout = std_message_timeout}
alert_messages[F16_AD_ENG_CHECK_IDLE]			= { message = _("ENGINE PARAMETERS FAILURE"),				message_timeout = std_message_timeout}
alert_messages[F16_AD_JFS_VERIFY_OFF]			= { message = _("JFS MUST BE OFF"),							message_timeout = std_message_timeout}

alert_messages[F16_AD_INS_CHECK_RDY]			= { message = _("INS NOT READY"),							message_timeout = std_message_timeout}

alert_messages[F16_AD_LEFT_HDPT_CHECK_RDY]		= { message = "",											message_timeout = std_message_timeout}
alert_messages[F16_AD_RIGHT_HDPT_CHECK_RDY]		= { message = "",											message_timeout = std_message_timeout}


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Start sequence
push_start_command(2.0,	{message = _("FIRST SEQUENCE IS RUNNING"),	message_timeout = stop_sequence_time})
--dofile(LockOn_Options.script_path.."test.lua")
push_start_command(dt,	{message = _("COMPLETE"),	message_timeout = std_message_timeout})
--


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- Stop sequence
push_stop_command(2.0,	{message = _("FENCE IN IS RUNNING"), message_timeout = start_sequence_time})
--
-- IFF on
push_stop_command(dt,		{message = _("- IFF MASTER KNOB"),	message_timeout = dt_mto})
push_stop_command(dt,		{device = devices.IFF_CONTROL_PANEL,	action = iff_commands.MasterKnob,				value = 0.3})

-- External lights
push_stop_command(dt,		{message = _("- External lights covert"),								message_timeout = dt_mto})
push_stop_command(dt,		{device = devices.EXTLIGHTS_SYSTEM,		action = extlights_commands.Master,				value = 0.1})

-- Enable ECM
push_stop_command(dt, 		{message = _("- ENABLE ECM"), 				message_timeout = 1 + dt_mto})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.PwrSw, 		value = 1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.XmitSw, 		value = -1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.OneBtn, 		value = 1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.TwoBtn, 		value = 1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.ThreeBtn, 	value = 1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.FourBtn, 		value = 1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.FiveBtn, 		value = 1.0})
push_stop_command(dt, 		{device = devices.ECM_INTERFACE, 		action = ecm_commands.SixBtn, 		value = 1.0})

-- Enable RWR and CMDS
push_stop_command(dt, 		{message = _("- ENABLE RWR AND CMDS"),			message_timeout = 1 + dt_mto})
push_stop_command(dt, 		{device = devices.RWR, 					action = rwr_commands.Power, 		value = 1.0})
push_stop_command(dt,		{device = devices.RWR,					action = rwr_commands.Search,				value = 1.0})
push_stop_command(dt,		{device = devices.RWR,					action = rwr_commands.Mode,				value = 1.0})
push_stop_command(dt,		{device = devices.CMDS,					action = cmds_commands.RwrSrc,		value = 1.0})
push_stop_command(dt,		{device = devices.CMDS,					action = cmds_commands.JmrSrc,		value = 1.0})
push_stop_command(dt,		{device = devices.CMDS,					action = cmds_commands.ChExp,		value = 1.0})
push_stop_command(dt,		{device = devices.CMDS,					action = cmds_commands.FlExp,		value = 1.0})
push_stop_command(dt,		{device = devices.CMDS,					action = cmds_commands.Mode, 		value = 0.2})

-- HMCS on
push_stop_command(dt,		{message = _("- HMCS SYMBOLOGY INT POWER KNOB - INT"),									message_timeout = dt_mto})
push_stop_command(dt,		{device = devices.HMCS,					action = hmcs_commands.IntKnob,					value = 0.8})

-- Master,Laser, RF arm
push_stop_command(dt,		{message = _("- ARMAMENT SWITCH"),			message_timeout = dt_mto})
push_stop_command(dt,		{device = devices.MMC,					action = mmc_commands.MasterArmSw,				value = 1.0})
push_stop_command(dt,		{device = devices.SMS,					action = sms_commands.LaserSw,					value = 1.0})
push_stop_command(dt,		{device = devices.UFC,					action = ufc_commands.RF_Sw,					value = 1.0})

-- Set Up MFDs
push_stop_command(dt, 		{message = _("- SET UP MFDS"), 				message_timeout = 1 + dt_mto})
-- Missle override
push_stop_command(dt, 		{device = devices.HOTAS, 				action = hotas_commands.THROTTLE_DOG_FIGHT, value = 1.0})
-- add HSD
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_13, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_13, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_7, 		value = 1.0})
-- XMT L16
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_6, 		value = 1.0})
-- add TGP
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_12, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_12, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_19, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_13, 		value = 1.0})

-- Dogfight override
push_stop_command(dt, 		{device = devices.HOTAS, 				action = hotas_commands.THROTTLE_DOG_FIGHT,  value = -1.0})
-- add HSD
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_13, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_13, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_7, 		value = 1.0})
-- add TGP
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_12, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_12, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_19, 		value = 1.0})
push_stop_command(dt, 		{device = devices.MFD_RIGHT, 			action = mfd_commands.OSB_13, 		value = 1.0})
-- exit overrides
push_stop_command(dt, 		{device = devices.HOTAS, 				action = hotas_commands.THROTTLE_DOG_FIGHT, value = 0.0})

-- clear pages on nav
clear_mfd_page(devices.MFD_LEFT, mfd_commands.OSB_12)
clear_mfd_page(devices.MFD_LEFT, mfd_commands.OSB_13)
push_stop_command(dt, {device = devices.MFD_LEFT, action = mfd_commands.OSB_14, value = 1.0})

-- clear pages on AA
press_rel(devices.UFC, ufc_commands.AA)
clear_mfd_page(devices.MFD_LEFT, mfd_commands.OSB_12)
clear_mfd_page(devices.MFD_LEFT, mfd_commands.OSB_13)
push_stop_command(dt, {device = devices.MFD_LEFT, action = mfd_commands.OSB_14, value = 1.0})

-- clear pages on AG
press_rel(devices.UFC, ufc_commands.AG)
clear_mfd_page(devices.MFD_LEFT, mfd_commands.OSB_12)
clear_mfd_page(devices.MFD_LEFT, mfd_commands.OSB_13)
push_stop_command(dt, {device = devices.MFD_LEFT, action = mfd_commands.OSB_14, value = 1.0})
press_rel(devices.UFC, ufc_commands.AG)

-- bullseye enable
push_stop_command(dt, 		{message = _("- ENABLE BULLSEYE"), 				message_timeout = 1 + dt_mto})
press_rel(devices.UFC, ufc_commands.LIST)
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DIG0_M_SEL, 		value = 1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DIG8_FIX, 		value = 1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DIG0_M_SEL, 		value = 1.0})

-- hmcs in pit enable
push_stop_command(dt, 		{message = _("- DISABLE HMCS PIT BLANK "), 				message_timeout = 1 + dt_mto})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.LIST, 		value = 1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DIG0_M_SEL, 		value = 1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.RCL, 		value = 1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DCS_DOWN, 		value = -1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DIG0_M_SEL, 		value = 1.0})

-- return ICP
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DCS_RTN, 		value = -1.0})
push_stop_command(dt, 		{device = devices.UFC, 			action = ufc_commands.DCS_RTN, 		value = 0.0})

-- Power intake hardpoints and FCR
push_stop_command(dt, 		{message = _("- POWER INTAKE HARDPOINTS"), 				message_timeout = 1 + dt_mto})
push_stop_command(dt,		{device = devices.SMS,					action = sms_commands.LeftHDPT,					value = 1.0})
push_stop_command(dt,		{device = devices.SMS,					action = sms_commands.RightHDPT,				value = 1.0})
push_stop_command(dt,		{device = devices.FCR,					action = fcr_commands.PwrSw,					value = 1.0})

-- Fuel Qty sel centerline
push_stop_command(dt, 		{message = _("- CENTERLINE FUEL GAUGE"), 				message_timeout = 1 + dt_mto})
push_stop_command(dt,		{device = devices.FUEL_INTERFACE,			action = fuel_commands.FuelQtySelSw,				value = 0.5})


--
push_stop_command(dt,	{message = _("FENCE IN COMPLETE"),message_timeout = std_message_timeout})
--
