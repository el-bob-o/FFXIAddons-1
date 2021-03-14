res = include('resources')

MasterGearList = {
	main = {
		{ name = "Grioavolr", 			setList = { { job = "SMN", sets = { } } } },
		{ name = "Solstice", 			setList = { { job = "GEO", sets = { "CombatIdleDT", "Fastcast", "ConserveMP", "Geomancy" } } } },
		{ name = "Daybreak", 			setList = { { job = "GEO", sets = { "IdleRefresh", "Healing", "Elemental", "MACC" } } } },
		{ name = "Tauret", 				setList = { { job = "THF", sets = { } } } },
		{ name = "Epeolatry", 			setList = { { job = "RUN", sets = { } } } },
		{ name = "Lionheart", 			setList = { { job = "RUN", sets = { } } } },
		{ name = "Aettir", 				setList = { { job = "RUN", sets = { } } } },
	},
	sub = {
		{ name = "Elan Strap +1", 		setList = { { job = "SMN", sets = { } } } },
		{ name = "Culminus", 			setList = { { job = "GEO", sets = { "CombatIdleDT", "Elemental" } } } },
		{ name = "Sors Shield", 		setList = { { job = "GEO", sets = { "HealingFastcast", "Healing" } } } },
		{ name = "Shijo", 				setList = { { job = "THF", sets = { } } } },
		{ name = "Immolation Grip",		setList = { { job = "RUN", sets = { } } } },
		{ name = "Balarama Grip",		setList = { { job = "RUN", sets = { } } } },
	},
	range = {
		{ name = "Dunna", 				setList = { { job = "GEO", sets = { "CombatIdleDT", "Geomancy", "MACC" } } } },
		{ name = "Wingcutter +1", 		setList = { { job = "THF", sets = { "Throwing" } } } },
	},
	ammo = {
		{ name = "Epitaph", 			setList = { { job = "SMN", sets = { "Idle", "BPDmg", "PrecastBP" } } } },
		{ name = "Per. Lucky Egg", 		setList = { { job = "SMN", sets = { "Dia", "Dia II", "Diaga" } },
													{ job = "GEO", sets = { "Dia", "Dia II", "Diaga", "Bio" } },
													{ job = "RUN", sets = { "TH" } },
													{ job = "THF", sets = { "TH" } },
													} },
		{ name = "Staunch Tathlum", 	setList = { { job = "RUN", sets = { "DT" } } } },
		{ name = "Aurgelmir Orb", 		setList = { { job = "RUN", sets = { "Hybrid", "WS_Any" } },
													{ job = "THF", sets = { "Hybrid", "WS_Any" } },
													} },
		{ name = "Seeth. Bomblet +1", 	setList = { { job = "RUN", sets = { "WS_STR", "Requeiescat" } },
													{ job = "THF", sets = { "WS_Str" } },
													} },
		{ name = "Yetshila", 			setList = { { job = "THF", sets = { "WS_Crit" } } } },
		{ name = "Ghastly Tathlum +1",	setList = { { job = "THF", sets = { "WS_Magical" } },
													{ job = "RUN", sets = { "Lunge" } },
													} },
	},
	head = {
		{ name = "Beckoner's Horn +1",	setList = { { job = "SMN", sets = { "Idle", "PrecastBP" } } } },
		{ name = "C. Palug Crown",		setList = { { job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Glyphic Horn +1",		setList = { { job = "SMN", sets = { "Astral Flow" } } } },
		{ name = "Azimuth Hood +1",		setList = { { job = "GEO", sets = { "CombatIdleDT", "Geomancy", "Full Circle" } } } },
		{ name = "Vanya Hood",			setList = { { job = "GEO", sets = { "Fastcast", "ConserveMP", "Healing" } } } },
		{ name = "Jhakri Coronal +1",	setList = { { job = "GEO", sets = { "Elemental", "MACC" } } } },
		{ name = "Bagua Galero +1",		setList = { { job = "GEO", sets = { "Drain" } } } },
		{ name = "Aya. Zucchetto +2",	setList = { { job = "RUN", sets = { "DT", "Hybrid", "WS_MagicAcc" } } }, 
			priority = 45 },
		{ name = "Erilaz Galea +1",		setList = { { job = "RUN", sets = { "Vivacious Pulse", "EnhancingAny" } } }, 
			priority = 91 },
		{ name = "Fu. Bandeau +2",		setList = { { job = "RUN", sets = { "PDT", "Battuta", "EnhancingPhalanx" } } }, 
			priority = 46 },
		{ name = "Despair Helm",		setList = { { job = "RUN", sets = { "Emnity" } } }, 
			priority = 46 },
		{ name = "Herculean Helm",		setList = { { job = "RUN", sets = { "WS_DEX", "WS_STR", "Requeiescat" } },
													{ job = "THF", sets = { "FastCast", "WS_Magical", "WS_Str" } },
													}, 
			priority = 38 },
		{ name = "Rune. Bandeau +2",	setList = { { job = "RUN", sets = { "Fastcast", "EnhancingRegen" } } }, 
			priority = 99 },
		{ name = "Malignance Chapeau",	setList = { { job = "THF", sets = { "Hybrid" } } } },
		{ name = "Pill. Bonnet +2",		setList = { { job = "THF", sets = { "WS_Any", "WS_Crit" } } } },
	},
	neck = {
		{ name = "Caller's Pendant",	setList = { { job = "SMN", sets = { "IdleRegen" } } } },
		{ name = "Smn. Collar +1",		setList = { { job =	"SMN", sets = { "BPDmg" } } } },
		{ name = "Incanter's Torque",	setList = { { job =	"SMN", sets = { "PrecastBP" } }, 
													{ job = "GEO", sets = { "ConserveMP", "Geomancy", "Healing" } },
													} },
		{ name = "Twilight Torque",		setList = { { job = "GEO", sets = { "CombatIdleDT" } } } },
		{ name = "Lissome Necklace",	setList = { { job = "GEO", sets = { "IdleRefresh" } },
													{ job = "THF", sets = { "WS_Any", "IdleRegen" } },
													} },
		{ name = "Voltsurge Torque",	setList = { { job = "GEO", sets = { "Fastcast", "MACC" } },
													{ job = "RUN", sets = { "Fastcast", "WS_MagicAcc" } },
													{ job = "THF", sets = { "Fastcast" } },
													} },
		{ name = "Futhark Torque +1",	setList = { { job = "RUN", sets = { "DT", "Hybrid", "Emnity", } } },
			priority = 30 },
		{ name = "Fotia Gorget",		setList = { { job = "ALL", sets = { "Fotia" } } } },
		{ name = "Lissome Necklace",	setList = { { job = "RUN", sets = { "Idle" } } } },
		{ name = "Erudit. Necklace",	setList = { { job = "THF", sets = { "Hybrid" } } } },
		{ name = "Satlada Necklace",	setList = { { job = "THF", sets = { "WS_Magical" } },
													{ job = "GEO", sets = { "Elemental" } },
													{ job = "RUN", sets = { "Lunge" } },
													} },
	},
	ear1 = {
		{ name = "Evan's Earring", 		setList = { { job = "SMN", sets = { "Idle", "PrecastBP" } } } }, 
		{ name = "Gelos Earring",		setList = { { job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Handler's Earring +1",setList = { { job = "GEO", sets = { "CombatIdleDT" } } } },
		{ name = "Loquac. Earring",		setList = { { job = "ALL", sets = { "Fastcast" } } } },
		{ name = "Mendi. Earring",		setList = { { job = "ALL", sets = { "HealingFastcast", "Healing" } } } },
		{ name = "Barkaro. Earring",	setList = { { job = "GEO", sets = { "Elemental", "MACC" } } } },
		{ name = "Moonshade Earring",	setList = { { job = "ALL", sets = { "TPBonus" } } } },
		{ name = "Ethereal Earring",	setList = { { job = "RUN", sets = { "DT" } } },
			priority = 15 },
		{ name = "Cessance Earring",	setList = { { job = "RUN", sets = { "Hybrid", "WS_Any" } },
													{ job = "THF", sets = { "Hybrid", "WS_Any", "WS_Crit", } },
													} },
		{ name = "Friomisi Earring",	setList = { { job = "RUN", sets = { "Emnity", "Lunge" } },
													{ job = "THF", sets = { "WS_Magical" } },
													} },
	},
	ear2 = {
		{ name = "C. Palug Earring",	setList = { { job = "SMN", sets = { "BPDmg", "PrecastBP" } } } },
		{ name = "Malignance Earring",	setList = { { job = "GEO", sets = { "Fastcast", "Elemental", "MACC" } } } },
		{ name = "Odnowa Earring +1",	setList = { { job = "GEO", sets = { "CombatIdleDT" } },
													{ job = "RUN", sets = { "DT", } }
													},
			priority = 110 },
		{ name = "Etiolation Earring",	setList = { { job = "RUN", sets = { "MDT", "Fastcast" } },
													{ job = "THF", sets = { "Fastcast" } }
													},
			priority = 110 },
		{ name = "Brutal Earring",		setList = { { job = "RUN", sets = { "Hybrid", "WS_Any" } },
													{ job = "THF", sets = { "Hybrid", "WS_Any" } }
													} },
		{ name = "Hecate's Earring",	setList = { { job = "RUN", sets = { "Lunge" } },
													{ job = "THF", sets = { "WS_Magical" } },
													} },
		{ name = "Odr Earring",			setList = { { job = "RUN", sets = { "WS_DEX" } },
													{ job = "THF", sets = { "WS_DEX", "WS_Crit" } },
													} },
	},
	body = {
		{ name = "Apogee Dalmatica +1",	setList = { { job = "SMN", sets = { "Idle", "BPDmg", "PrecastBP" } } } },
		{ name = "Vrikodara Jupon",		setList = { { job = "GEO", sets = { "CombatIdleDT", "IdleRefresh", "Fastcast" } } } },
		{ name = "Bagua Tunic +1", 		setList = { { job = "GEO", sets = { "Geomancy", "Bolster" } } } },
		{ name = "Geomancy Tunic +2", 	setList = { { job = "GEO", sets = { "Life Cycle" } } } },
		{ name = "Jhakri Robe +1", 		setList = { { job = "GEO", sets = { "Elemental", "MACC" } } } },
		{ name = "Councilor's Garb", 	setList = { { job = "ALL", sets = { "Adoulin" } } } },
		{ name = "Futhark Coat +3", 	setList = { { job = "RUN", sets = { "DT", "Elemental Sforzo", "Liement", "WS_DEX", "WS_STR", "Requeiescat", "IdleRegen" } } },
			priorty = 119 },
		{ name = "Runeist's Coat +2", 	setList = { { job = "RUN", sets = { "PDT", "Valiance" } } },
			priorty = 208 },
		{ name = "Ayanmo Corazza +2", 	setList = { { job = "RUN", sets = { "Hybrid" } } },
			priorty = 57 },
		{ name = "Emet Harness +1", 	setList = { { job = "RUN", sets = { "Emnity" } } },
			priorty = 61 },
		{ name = "Samnuha Coat", 		setList = { { job = "RUN", sets = { "Lunge", "WS_MagicAcc", "Fastcast" } },
													{ job = "THF", sets = { "Fastcast", "WS_Magical" } },
													},
			priorty = 63 },
		{ name = "Malignance Tabard", 	setList = { { job = "THF", sets = { "Hybrid" } } } },
		{ name = "Pillager's Vest +2", 	setList = { { job = "THF", sets = { "Hide", "WS_Any", "WS_Crit", "WS_Str" } } } },
	},
	hands = {
		{ name = "Asteria Mitts +1", 	setList = { { job = "SMN", sets = { "Idle" } } } },
		{ name = "Merlinic Dastanas", 	setList = { { job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Glyphic Bracers +1", 	setList = {	{ job = "SMN", sets = { "PrecastBP" } } } },
		{ name = "Geo. Mitaines +2", 	setList = {	{ job = "GEO", sets = { "CombatIdleDT", "Geomancy" } } } },
		{ name = "Bagua Mitaines +1", 	setList = {	{ job = "GEO", sets = { "ElementalFastcast", "Curative Recantation" } } } },
		{ name = "Jhakri Cuffs +1", 	setList = {	{ job = "GEO", sets = { "Elemental", "MACC" } } } },
		{ name = "Aya. Manopolas +1", 	setList = { { job = "RUN", sets = { "DT" } } },
			priorty = 22 },
		{ name = "Leyline Gloves", 		setList = { { job = "RUN", sets = { "Lunge", "WS_MagicAcc", "Fastcast" } },
													{ job = "THF", sets = { "FastCast", "WS_Magical" } },
													},
			priorty = 25 },
		{ name = "Meg. Gloves +2", 		setList = { { job = "RUN", sets = { "PDT", "WS_DEX", "WS_STR", "Requeiescat" } },
													{ job = "THF", sets = { "Hybrid", "WS_Any", "WS_Str" } },
													},
			priorty = 30 },
		{ name = "Runeist's Mitons +2",	setList = { { job = "RUN", sets = { "Gambit", "EnhancingAny" } } },
			priorty = 75 },
		{ name = "Taeon Gloves", 		setList = { { job = "RUN", sets = { "EnhancingPhalanx" } } },
			priorty = 25 },
		{ name = "Turms Mittens +1", 	setList = { { job = "RUN", sets = { "Hybrid" } } },
			priorty = 25 },
		{ name = "Plun. Armlets +1", 	setList = {	{ job = "THF", sets = { "TH" } } } },
		{ name = "Pill. Armlets +2", 	setList = {	{ job = "THF", sets = { "TrickAttack" } } } },
		{ name = "Mummu Wrists +2", 	setList = {	{ job = "THF", sets = { "WS_Crit" } } } },
	},
	ring1 = {
		{ name = "Vocane Ring +1",		setList = {	{ job = "SMN", sets = { "Idle" } },
													{ job = "GEO", sets = { "CombatIdleDT" } },
													{ job = "RUN", sets = { "DT" } },
													{ job = "THF", sets = { "Hybrid", "Lilith" } },
													} },
		{ name = "Varar Ring", 			setList = { { job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Evoker's Ring",		setList = { { job = "SMN", sets = { "PrecastBP" } } } },
		{ name = "Resonance Ring",		setList = { { job = "GEO", sets = { "Elemental" } } } },
		{ name = "Locus Ring",			setList = { { job = "RUN", sets = { "Lunge" } },
													{ job = "THF", sets = { "WS_Magical" } },
													} },
		{ name = "Rajas Ring",			setList = { { job = "RUN", sets = { "WS_DEX", "WS_STR" } },
													{ job = "THF", sets = { "WS_DEX", "WS_STR" } },
													} },
		{ name = "Rufescent Ring",		setList = { { job = "RUN", sets = { "Requeiescat" } } } },
		{ name = "Mummu Ring",			setList = { { job = "THF", sets = { "WS_Crit" } } } },
	},
	ring2 = {
		{ name = "Stikini Ring +1", 	setList = { { job =	"SMN", sets = { "Idle", "PrecastBP" } } } },
		{ name = "Varar Ring",			setList = { { job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Dark Ring",			setList = { { job = "GEO", sets = { "CombatIdleDT" } },
													{ job = "RUN", sets = { "DT" } },
													} },
		{ name = "Vertigo Ring",		setList = { { job = "GEO", sets = { "Elemental" } } } },
		{ name = "Chirich Ring",		setList = { { job = "GEO", sets = { "IdleRefresh" } },
													{ job = "RUN", sets = { "IdleRegen" } },
													{ job = "THF", sets = { "IdleRegen" } }
													} },
		{ name = "Gelatinous Ring +1",	setList = { { job = "RUN", sets = { "PDT" } },
													{ job = "THF", sets = { "Hybrid" } },
													},
			priority = 135 },
		{ name = "Supershear Ring",		setList = { { job = "RUN", sets = { "Emnity" } } },
			priority = 30 },
		{ name = "Ramuh Ring",			setList = { { job = "RUN", sets = { "WS_DEX" } },
													{ job = "THF", sets = { "WS_DEX", "WS_Crit" } },
													} },
		{ name = "Vertigo Ring",		setList = { { job = "RUN", sets = { "WS_MagicAcc" } } } },
	},
	back = {
		{ name = "Campestres's Cape",	setList = { { job = "SMN", sets = { "Idle", "BPDmg" } } } },
		{ name = "Mecisto. Mantle",		setList = { { job = "ALL", sets = { "CP" } } } },
		{ name = "Conveyance Cape",		setList = { { job = "SMN", sets = { "PrecastBP" } } } },
		{ name = "Lifestream Cape",		setList = { { job = "GEO", sets = { "CombatIdleDT", "Fastcast", "Geomancy", } } } },
		{ name = "Solemnity Cape",		setList = { { job = "GEO", sets = { "ConserveMP", "Healing" } } } },
		{ name = "Nantosuelta's Cape",	setList = { { job = "GEO", sets = { "Elemental", "MACC", "Life Cycle" } } } },
		{ name = "Ogma's Cape", 		setList = { { job = "RUN", sets = { "Hybrid", "Valiance", "WS_DEX" } } }, 
			augments = {'DEX+20','Accuracy+20 Attack+20','DEX+10', '"Dbl.Atk."+10','Phys. dmg. taken-10%'} },
		{ name = "Ogma's Cape", 		setList = { { job = "RUN", sets = { "WS_STR", "Requeiescat" } } }, 
			augments = {'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10'} },
		{ name = "Evasionist's Cape",	setList = { { job = "RUN", sets = { "DT", "Emnity" } } } },
		{ name = "Izdubar Mantle",		setList = { { job = "RUN", sets = { "Lunge", "WS_MagicAcc" } },
													{ job = "THF", sets = { "WS_Magical" } },
													} },
		{ name = "Toutatis's Cape",		setList = { { job = "THF", sets = { "Hybrid", "SneakAttack", "WS_Any", "WS_Crit" } } } },
		{ name = "Repulse Mantle",		setList = { { job = "THF", sets = { "Lilith" } } } },
	},
	waist = {
		{ name = "Fucho-no-Obi", 		setList = { { job = "SMN", sets = { "Idle" } } } },
		{ name = "Lucidity Sash", 		setList = { { job = "SMN", sets = { "PrecastBP" } } } },
		{ name = "Incarnation Sash",	setList = { { job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Chaac Belt", 			setList = { { job = "SMN", sets = { "Dia", "Dia II", "Diaga" } },
													{ job = "GEO", sets = { "Dia", "Dia II", "Diaga", "Bio" } },
													{ job = "RUN", sets = { "TH" } },
													{ job = "THF", sets = { "TH" } },
													} },
		{ name = "Isa Belt", 			setList = { { job = "GEO", sets = { "CombatIdleDT" } } } },
		{ name = "Witful Belt", 		setList = { { job = "GEO", sets = { "Fastcast" } } } },
		{ name = "Hachirin-no-Obi",		setList = { { job = "ALL", sets = { "WeatherObi" } } } },
		{ name = "Yamabuki-no-Obi",		setList = { { job = "RUN", sets = { "Lunge" } },
													{ job = "GEO", sets = { "Elemental", "MACC" } },
													} },
		{ name = "Flume Belt +1",		setList = { { job = "RUN", sets = { "PDT" } } } },
		{ name = "Fotia Belt",			setList = { { job = "ALL", sets = { "Fotia" } } } },
		{ name = "Sailfi Belt +1",		setList = { { job = "RUN", sets = { "Hybrid", "WS_DEX", "WS_STR", } },
													{ job = "THF", sets = { "Hybrid", "WS_Any", "WS_Crit", } },
													} },
	},
	legs = {
		{ name = "Assid. Pants +1", 	setList = { { job = "SMN", sets = { "Idle" } },
													{ job = "GEO", sets = { "IdleRefresh" } },
													} },
		{ name = "Enticer's Pants", 	setList = {	{ job = "SMN", sets = { "BPDmg" } } } },
		{ name = "Glyphic Spats +1",	setList = { { job = "SMN", sets = { "PrecastBP" } } } },
		{ name = "Psycloth Lappas",		setList = { { job = "GEO", sets = { "CombatIdleDT" } } } },
		{ name = "Geomancy Pants +2",	setList = { { job = "GEO", sets = { "Fastcast" } } } },
		{ name = "Bagua Pants +2",		setList = { { job = "GEO", sets = { "Geomancy", "Elemental", "MACC" } } } },
		{ name = "Aya. Cosciales +1",	setList = { { job = "RUN", sets = { "DT" } } },
			priority = 45 },
		{ name = "Carmine Cuisses +1",	setList = { { job = "RUN", sets = { "Requeiescat", "Movement", "EnhancingAny" } } },
			priority = 50 },
		{ name = "Eri. Leg Guards +1",	setList = { { job = "RUN", sets = { "PDT", "Emnity" } } },
			priority = 80 },
		{ name = "Futhark Trousers +1",	setList = { { job = "RUN", sets = { "Valiance", "FastcastEnhancing" } } },
			priority = 87 },
		{ name = "Meg. Chausses +2",	setList = { { job = "RUN", sets = { "Hybrid", "WS_DEX", "WS_STR" } },
													{ job = "THF", sets = { "Hybrid", "WS_STR" } }
													},
			priority = 35 },
		{ name = "Rawhide Trousers",	setList = { { job = "RUN", sets = { "WS_MagicAcc", "Fastcast" } },
													{ job = "THF", sets = { "WS_Magical", "Fastcast" } },
													},
			priority = 35 },
		{ name = "Pill. Culottes +2",	setList = { { job = "THF", sets = { "WS_Any", "WS_Crit" } } } },
	},
	feet = {
		{ name = "Apogee Pumps +1",		setList = { { job = "SMN", sets = { "Idle", "BPDmg" } } } },
		{ name = "Glyph. Pigaches +1", 	setList = { { job = "SMN", sets = { "PrecastBP" } } } },
		{ name = "Azimuth Gaiters +1", 	setList = { { job = "GEO", sets = { "CombatIdleDT", "Geomancy" } } } },
		{ name = "Geo. Sandals +2", 	setList = { { job = "GEO", sets = { "IdleRefresh" } } } },
		{ name = "Regal Pumps +1", 		setList = { { job = "GEO", sets = { "Fastcast", "Healing" } } } },
		{ name = "Jhakri Pigaches +1", 	setList = { { job = "GEO", sets = { "Elemental", "MACC" } } } },
		{ name = "Bagua Sandals +1", 	setList = { { job = "GEO", sets = { "Radial Arcana" } } } },
		{ name = "Aya. Gambieras +1",	setList = { { job = "RUN", sets = { "DT" } } },
			priority = 11 },
		{ name = "Carmine Greaves +1",	setList = { { job = "RUN", sets = { "Fastcast" } } },
			priority = 15 },
		{ name = "Erilaz Greaves +1",	setList = { { job = "RUN", sets = { "PDT", "Emnity" } } },
			priority = 18 },
		{ name = "Futhark Boots +1",	setList = { { job = "RUN", sets = { "Rayke" } } },
			priority = 13 },
		{ name = "Herculean Boots",		setList = { { job = "RUN", sets = { "Hybrid", "WS_DEX", "WS_STR", "WS_MagicAcc", "Requeiescat" } },
													{ job = "THF", sets = { "WS_Any", "WS_Magical", "WS_STR" } }
													},
			priority = 9 },
		{ name = "Skulk. Poulaines +1", setList = { { job = "THF", sets = { "TH" } } } },
		{ name = "Malignance Boots", 	setList = { { job = "THF", sets = { "Hybrid" } } } },
		{ name = "Mummu Gamash. +1", 	setList = { { job = "THF", sets = { "WS_Crit" } } } },
		{ name = "Jute Boots +1", 		setList = { { job = "THF", sets = { "Movement" } } } },
	}
}

equipable_bags = { --0, -- don't care inventory 
					8, 10, 11, 12 } -- Mog Wardrobes

function get_set_for_job(job)
	local sets = {}
	populate_set(sets, job)
	return sets
end

function populate_set(sets, job)
	for slot,gears in pairs(MasterGearList) do
		for k,gear in pairs(gears) do
			add_to_set(sets, gear, slot, job)
		end
	end
end

function add_to_set(sets, gear, slot, job)
	for k,setData in pairs(gear.setList) do
		if setData.job == job or setData.job == "ALL" then
			for k2, set in pairs(setData.sets) do
				if sets[set] == nil then
					sets[set] = { }
				end
				if sets[set][slot] == nil then
					sets[set][slot] = gear
				else
					add_to_chat(122, "Duplicate found at " .. tostring(set) .. " for " .. tostring(slot) .. " slot.")
				end
			end
		end
	end
end

function master_gear_list_command(args)
	if args[1] == "countGear" then
		count_gear(args)
	elseif args[1] == "extraGear" then
		print_extra_gear_not_in_master_list(args)
	elseif args[1] == "missingGear" then
		print_missing_gear(args)
	end
end

function count_gear(args)
	add_to_chat(122, "Gear Count")
	local exclusion = nil
	if args[2] == "exclude" and args[3] then
		exclusion = args[3]:split(',')
		add_to_chat(122,  "Excluding: " .. args[3])
	end
	local totalGearCount = 0
	for slot,gears in pairs(MasterGearList) do
		local gearCount = 0
		for k, gear in pairs(gears) do
			if exclusion ~= nil then
				for k2, set in pairs(gear.setList) do
					if not exclusion:contains(set.job) then
						gearCount = gearCount + 1
						totalGearCount = totalGearCount + 1
						break
					end
				end
			else
				gearCount = gearCount + 1
				totalGearCount = totalGearCount + 1
			end
		end
		add_to_chat(122, tostring(slot) .. ": " .. tostring(gearCount))
	end
	add_to_chat(122, "Total: " .. tostring(totalGearCount))
end

function print_extra_gear_not_in_master_list(args)
	add_to_chat(122, "Extra Gear")
	local exclusion = nil
	if args[2] == "exclude" and args[3] then
		exclusion = args[3]:split(',')
		add_to_chat(122,  "Excluding: " .. args[3])
	end
	local gearSet = get_list_of_gear_in_master_list(exclusion)
	local invSet = get_list_of_gear_in_equipable_inventory()
	for item, bagId in pairs(invSet) do
		if gearSet[item] == nil then
			add_to_chat(122, item .. " in " .. res.bags[bagId].name)
		end
	end	
end

function get_list_of_gear_in_master_list(exclusion)
	local gearSet = S{}
	for slot,gears in pairs(MasterGearList) do
		for k, gear in pairs(gears) do
			if exclusion ~= nil then
				for k2, set in pairs(gear.setList) do
					if not exclusion:contains(set.job) then
						gearSet[gear.name] = 1
						break
					end
				end
			else
				gearSet[gear.name] = 1
			end
		end
	end
	return gearSet
end

function get_list_of_gear_in_equipable_inventory()
	local inventorySet = S{}
	for _, bagId in pairs(equipable_bags) do
		local inv = windower.ffxi.get_items(bagId)
		for _, item in pairs(inv) do
			if type(item) == 'table' then
				if item.id ~= nil and item.id ~= 0 and res.items[item.id] then
					inventorySet[res.items[item.id].name] = bagId
				end
			end
		end
	end
	return inventorySet
end

function print_missing_gear(args)
	add_to_chat(122, "Missing Gear")
	local exclusion = nil
	if args[2] == "exclude" and args[3] then
		exclusion = args[3]:split(',')
		add_to_chat(122,  "Excluding: " .. args[3])
	end
	local gearSet = get_list_of_gear_in_master_list(exclusion)
	local invSet = get_list_of_gear_in_equipable_inventory()
	for item, _ in pairs(gearSet) do
		if invSet[item] == nil then
			add_to_chat(122, item)
		end
	end
end