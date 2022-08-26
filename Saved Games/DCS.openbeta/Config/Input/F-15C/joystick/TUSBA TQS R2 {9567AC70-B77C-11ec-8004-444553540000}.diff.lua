local diff = {
	["axisDiffs"] = {
		["a2001cdnil"] = {
			["name"] = "Pitch",
			["removed"] = {
				[1] = {
					["key"] = "JOY_Y",
				},
			},
		},
		["a2002cdnil"] = {
			["name"] = "Roll",
			["removed"] = {
				[1] = {
					["key"] = "JOY_X",
				},
			},
		},
		["a2003cdnil"] = {
			["name"] = "Rudder",
			["removed"] = {
				[1] = {
					["key"] = "JOY_RZ",
				},
			},
		},
		["a2004cdnil"] = {
			["added"] = {
				[1] = {
					["key"] = "JOY_RY",
				},
			},
			["name"] = "Thrust",
			["removed"] = {
				[1] = {
					["key"] = "JOY_Z",
				},
			},
		},
		["a2027cdnil"] = {
			["added"] = {
				[1] = {
					["key"] = "JOY_Z",
				},
			},
			["name"] = "Radar Horizontal",
		},
		["a2028cdnil"] = {
			["added"] = {
				[1] = {
					["key"] = "JOY_RX",
				},
			},
			["name"] = "Radar Vertical",
		},
		["a2033cdnil"] = {
			["added"] = {
				[1] = {
					["filter"] = {
						["curvature"] = {
							[1] = 0.51,
						},
						["deadzone"] = 0.2,
						["invert"] = true,
						["saturationX"] = 0.62,
						["saturationY"] = 1,
						["slider"] = false,
					},
					["key"] = "JOY_X",
				},
			},
			["name"] = "TDC Slew Horizontal",
		},
		["a2034cdnil"] = {
			["added"] = {
				[1] = {
					["filter"] = {
						["curvature"] = {
							[1] = 0.5,
						},
						["deadzone"] = 0.17,
						["invert"] = false,
						["saturationX"] = 0.61,
						["saturationY"] = 1,
						["slider"] = false,
					},
					["key"] = "JOY_Y",
				},
			},
			["name"] = "TDC Slew Vertical",
		},
	},
	["keyDiffs"] = {
		["d100pnilu1627cdnilvdnilvpnilvunil"] = {
			["name"] = "Target Lock",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN3",
				},
			},
		},
		["d101pnilunilcdnilvdnilvpnilvunil"] = {
			["name"] = "Weapon Change",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN4",
				},
			},
		},
		["d350pnilu351cdnilvdnilvpnilvunil"] = {
			["name"] = "Weapon Release",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN2",
				},
			},
		},
		["d84pnilu85cdnilvdnilvpnilvunil"] = {
			["name"] = "Weapon Fire",
			["removed"] = {
				[1] = {
					["key"] = "JOY_BTN1",
				},
			},
		},
	},
}
return diff