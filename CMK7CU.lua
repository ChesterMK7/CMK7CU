assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/vouchers.lua"))()

SMODS.Atlas {
	key = "CMK7CU",
	path = "CMK7CU.png",
	px = 71,
	py = 95
}

SMODS.Rarity {
    key = "diva",
	loc_txt = {
		name = 'Diva'
	},
    default_weight = 0,
    badge_colour = HEX("46bdc6"),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "linux",
	loc_txt = {
		name = 'Linux'
	},
    default_weight = 0,
    badge_colour = HEX("969696"),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Consumable {
    key = 'battle_bus',
	loc_txt = {
		name = 'Battle Bus',
		text = {
			"Creates a",
			"{C:cmk7_diva}Diva{} Joker",
			"{C:inactive}(Must have room){}"
		}
	},
	set = 'Spectral',
    hidden = true,
    soul_set = 'Tarot',
	soul_rate = 0.015,
    pos = { x = 0, y = 2 },
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Joker', rarity = "cmk7_diva"})
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}

SMODS.Booster {
    key = "linux_pack",
    loc_txt = {
		name = 'Linux Pack',
		text = {
			"Choose {C:attention}#1#{} of",
			"up to {C:attention}#2#{} {C:cmk7_linux}Linux{} Jokers"
		}
	},
    weight = 0.15,
    kind = 'Buffoon',
    cost = 10,
    atlas = "CMK7CU",
    pos = { x = 0, y = 0 },
    config = { extra = 2, choose = 1 },
    group_key = "k_buffoon_pack", -- Delete this if you're using `group_name` in `loc_txt`
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra },
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.BUFFOON_PACK)
    end,
    create_card = function(self, card, i)
        return { set = "Joker", rarity = "cmk7_linux", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "cmk7_buf" }
    end,
}

SMODS.Consumable {
    key = 'install_medium',
	loc_txt = {
		name = 'Install Medium',
		text = {
			"Creates a",
			"{C:cmk7_linux}Linux{} Joker",
			"{C:inactive}(Must have room){}"
		}
	},
	set = 'Spectral',
    hidden = true,
    soul_set = 'Tarot',
	soul_rate = 0.03,
    pos = { x = 0, y = 2 },
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.04,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Joker', rarity = "cmk7_linux"})
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end
}

SMODS.Back{
    name = "Diva Deck",
    key = "diva_deck",
    pos = {x = 0, y = 0},
    config = {diva = true},
    loc_txt = {
        name = "Diva Deck",
        text ={
            "Start with a random",
            "{C:cmk7_diva}Diva{} joker"
        },
    },
    atlas = 'CMK7CU',
    pos = { x = 0, y = 7 },
    unlocked = true,
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
				if G.jokers then
					if #G.jokers.cards < G.jokers.config.card_limit then
                		SMODS.add_card({ set = 'Joker', rarity = "cmk7_diva"})
                	return true
					end
				end
            end
        }))
    end
}
