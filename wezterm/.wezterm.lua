-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
-- config.front_end = "Software"

-- Windows specific
if wezterm.target_triple:find("windows") ~= nil then
	config.default_domain = "WSL:Arch"
	-- config.window_background_opacity = 0.96
	-- config.win32_system_backdrop = "Tabbed"
	-- config.window_background_image = "c:\\Users\\jvenant\\Downloads\\abstract-art.gif"
	-- config.window_background_image_hsb = { brightness = 0.03, hue = 1, saturation = 0.2 }
end
config.window_background_gradient = {
	colors = { "#000000", "#000000", "#000000", "#222046" },
	orientation = { Radial = { cx = 0, cy = 0, radius = 1.25 } },
	noise = 0,
}
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.4,
}
-- This is where you actually apply your config choices

--config.font = wezterm.font 'MesloLGS NF'
config.font = wezterm.font_with_fallback({
	"RobotoMono Nerd Font Mono",
})

config.font_size = 10
--
-- config.window_decorations = "RESIZE"
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
--
-- config.enable_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.colors = {
	tab_bar = {
		active_tab = { bg_color = "#7070a9", fg_color = "#efeff5" },
		inactive_tab = { bg_color = "#303050", fg_color = "#56568f" },
	},
}

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "'", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "d", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
	{ key = "b", mods = "LEADER", action = wezterm.action.ActivateLastTab },
	{ key = "m", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "s", mods = "LEADER", action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }) },
}
for i = 1, 8 do
	-- CTRL+ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- For example, changing the color scheme:
-- config.color_scheme = "Default (dark) (terminal.sexy)"

wezterm.on("update-status", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if window:is_focused() then
		overrides.window_background_opacity = 0.96
		-- overrides.win32_system_backdrop = "Tabbed"
		-- -- overrides.window_background_image = "c:\\Users\\jvenant\\Downloads\\abstract-art.gif"
		overrides.window_background_image_hsb = nil
		overrides.color_scheme = "Default (dark) (terminal.sexy)"
	else
		overrides.window_background_opacity = 0.92
		-- overrides.win32_system_backdrop = "Tabbed"
		-- overrides.window_background_image = nil
		-- overrides.window_background_image_hsb = nil
		overrides.color_scheme = "Dawn (terminal.sexy)"
		overrides.window_background_image_hsb = { brightness = 0.2, hue = 0.5, saturation = 0.2 }
	end
	window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
