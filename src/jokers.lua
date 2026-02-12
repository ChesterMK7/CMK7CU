SMODS.Joker {
	key = 'six_seven',
	loc_txt = {
		name = 'Six Seven',
		text = {
			"Each played {C:attention}6{} or {C:attention}7",
			"gives {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult when scored"
		}
	},
	config = { extra = { chips = 6, mult = 7 } },
	rarity = 1,
	atlas = 'CMK7CU',
	pos = { x = 1, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 6 or context.other_card:get_id() == 7 then
				return {
					chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
    key = "gold_standard",
    loc_txt = {
		name = 'Gold Standard',
		text = {
			"Each {C:gold}Gold{} card held in",
			"hand gives an additional {C:gold}$#1#{}",
			"at the end of each round"
		}
	},
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'CMK7CU',
    pos = { x = 0, y = 2 },
    config = { extra = { dollars = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.end_of_round and SMODS.has_enhancement(context.other_card, 'm_gold') then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end,
    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_gold') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = "leek",
    loc_txt = {
		name = 'Leek',
		text = {
			"{C:chips}+#1#{} if played hand",
			"is a {C:attention}High Card{}",
            "{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
    blueprint_compat = true,
    no_pool_flag = 'leek_extinct',
    rarity = 1,
    cost = 5,
    atlas = 'CMK7CU',
    eternal_compat = false,
    pos = { x = 2, y = 2 },
    config = { extra = { t_chips = 100, odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.t_chips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == 'High Card' then
            return {
                chips = card.ability.extra.t_chips
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'leek', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.leek_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = "baguette",
    loc_txt = {
		name = 'Baguette',
		text = {
			"{C:chips}+#1#{} if played hand",
			"is a {C:attention}Pair{}",
            "{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
    blueprint_compat = true,
    no_pool_flag = 'baguette_extinct',
    rarity = 1,
    cost = 5,
    atlas = 'CMK7CU',
    eternal_compat = false,
    pos = { x = 3, y = 2 },
    config = { extra = { t_chips = 200, odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.t_chips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == 'Pair' then
            return {
                chips = card.ability.extra.t_chips
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'baguette', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.baguette_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = "flip_phone",
    loc_txt = {
		name = 'Flip Phone',
		text = {
			"{C:chips}+#1#{} if played hand",
			"is a {C:attention}Three of a Kind{}",
            "{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
    blueprint_compat = true,
    no_pool_flag = 'phone_extinct',
    rarity = 1,
    cost = 5,
    atlas = 'CMK7CU',
    eternal_compat = false,
    pos = { x = 4, y = 2 },
    config = { extra = { t_chips = 300, odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.t_chips, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.scoring_name == 'Three of a Kind' then
            return {
                chips = card.ability.extra.t_chips
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'flip_phone', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.phone_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = "fort_calcium",
     loc_txt = {
		name = 'Fort Calcium',
		text = {
			"Each {C:attention}Stone{} card held in",
			"hand gives {C:chips}+#1#{} Chips"
		}
	},
    blueprint_compat = true,
    rarity = 1,
    cost = 5,
    atlas = "CMK7CU",
    pos = { x = 0, y = 5 },
    config = { extra = { chips = 100 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and SMODS.has_enhancement(context.other_card, 'm_stone') then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end,
    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = "driving_in_my_car",
    loc_txt = {
		name = 'Driving in my Car',
		text = {
			"Gains {X:mult,C:white}X#1#{} mult for",
			"each {C:attention}consecutive{} hand",
            "played while scoring a {C:attention}King{}",
            "{C:inactive}(Currently {}{X:mult,C:white} X#2# {}{C:inactive} Mult){}"

		}
	},
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 2,
    cost = 6,
    atlas = 'CMK7CU',
    pos = { x = 5, y = 2 },
    config = { extra = { xmult_gain = 0.25, xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local faces = true
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card:get_id() == 13 then
                    faces = false
                    break
                end
            end
            if faces then
                local last_mult = card.ability.extra.xmult
                card.ability.extra.xmult = 1
                if last_mult > 0 then
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker {
	key = 'high_roller',
	loc_txt = {
		name = 'High Roller',
		text = {
			"Retrigger each played",
			"{C:attention}6{}, {C:attention}7{}, {C:attention}8{}, {C:attention}9{}, or {C:attention}10{}",
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 2, --Uncommon (2), Common for testing
	atlas = 'CMK7CU',
	pos = { x = 8, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 6 or
				context.other_card:get_id() == 7 or
				context.other_card:get_id() == 8 or
				context.other_card:get_id() == 9 or
				context.other_card:get_id() == 10 then
				return {
					--message = 'Again!',
					repetitions = card.ability.extra.repetitions--,
					--card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'ace_flag',
	loc_txt = {
		name = 'Ace Flag',
		text = {
			"Retrigger each played",
			"{C:attention}Ace{} an additional",
			"{C:attention}#1#{} times"
		}
	},
	config = { extra = { repetitions = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
	rarity = 2, --Uncommon (2), Common for testing
	atlas = 'CMK7CU',
	pos = { x = 5, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 14 then
				return {
					--message = 'Again!',
					repetitions = card.ability.extra.repetitions--,
					--card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
    key = "ddr5",
	loc_txt = {
		name = 'DDR5',
		text = {
			"{C:attention}Increases sell value{}",
			"{C:attention}multiplicatively{} after",
			"each round",
            "{C:inactive}(Maximum of {}{C:gold}$2000{}{C:inactive}){}"
		}
	},
    blueprint_compat = false,
    rarity = 2, --Uncommon (2), Common for testing
    cost = 7,
	atlas = 'CMK7CU',
    pos = { x = 2, y = 0 },
    config = { extra = { price = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.price } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
			if card.ability.extra_value == 0 then
				card.ability.extra_value = 2
			else 	
            	card.ability.extra_value = math.floor(card.ability.extra_value * card.ability.extra.price)
                if (card.ability.extra_value > 2000) then
                    card.ability.extra_value = 2000
                end
			end
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker {
    key = "pear",
    loc_txt = {
		name = 'Pear',
		text = {
			"If played hand is",
			"a {C:attention}Pair{} or {C:attention}Two Pair{},",
            "level up the played hand",
            "{C:green}#1# in #2#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
    blueprint_compat = true,
    no_pool_flag = 'pear_extinct',
    rarity = 2,
    cost = 5,
    atlas = 'CMK7CU',
    eternal_compat = false,
    pos = { x = 6, y = 2 },
    config = { extra = { odds = 8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and (context.scoring_name == 'Pair' or context.scoring_name == 'Two Pair') then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'pear', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.pear_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = "frontrunning",
	loc_txt = {
		name = 'Frontrunning',
		text = {
			"This Joker gives {X:mult,C:white} X#2# {} Mult",
			"for each {C:attention}additional level{} of the",
			"played {C:attention}poker hand{}"
		}
	},
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
	atlas = 'CMK7CU',
    pos = { x = 3, y = 3 },
    config = { extra = { Xmult = 1, Xmult_gain = 0.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_gain } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
            card.ability.extra.Xmult = 1 + card.ability.extra.Xmult_gain * (G.GAME.hands[context.scoring_name].level - 1)
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
    key = "french_revolution",
	loc_txt = {
		name = 'French Revolution',
		text = {
			"If {C:attention}first hand{} of round is",
			"a single {C:attention}King{} or {C:attention}Queen{},",
			"destroy it and create",
            "a {C:spectral}Spectral{} card",
			"{C:inactive}(Must have room){}"
		}
	},
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
	atlas = 'CMK7CU',
    pos = { x = 2, y = 3 },
    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and (context.full_hand[1]:get_id() == 13 or context.full_hand[1]:get_id() == 12) and G.GAME.current_round.hands_played == 0 then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Spectral',
                                soulable = true
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_spectral'),
                        colour = G.C.PURPLE,
                        remove = true
                    }
                end
                return {
                    remove = true
                }
            end
        end
    end
}

SMODS.Joker {
    key = "terry_davis",
	loc_txt = {
		name = 'Terry Davis',
		text = {
			"Each played card of",
            "{C:hearts}Heart{} or {C:diamonds}Diamond{} suit",
            "gives {X:mult,C:white} X#1# {} Mult",
			"when scored, debuffs all",
            "{C:clubs}Clubs{} and {C:spades}Spades{}"
		}
	},
    blueprint_compat = true,
    rarity = 2,
    atlas = 'CMK7CU',
	cost = 6,
    pos = { x = 8, y = 2 },
    config = { extra = { Xmult = 1.75 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    update = function(self, card, dt)
		if G.deck and card.added_to_deck then
			for i, v in pairs(G.deck.cards) do
				if v:is_suit("Clubs") or v:is_suit("Spades") then
					v:set_debuff(true)
				end
			end
		end
		if G.hand and card.added_to_deck then
			for i, v in pairs(G.hand.cards) do
				if v:is_suit("Clubs") or v:is_suit("Spades") then
					v:set_debuff(true)
				end
			end
		end
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds")) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

SMODS.Joker {
    key = "the_grimstoner",
    loc_txt = {
		name = 'TheGrimstoner',
		text = {
			"Each played {C:attention}Stone{}",
            "card has a {C:green}#1# in #2#{}",
            "chance to create a {C:tarot}Tarot{}",
			"card when scored"
		}
	},
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    atlas = 'CMK7CU',
    pos = { x = 6, y = 5 },
    config = { extra = { odds = 3 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'vremade_8ball')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if (SMODS.has_enhancement(context.other_card, 'm_stone')) and SMODS.pseudorandom_probability(card, 'vremade_8ball', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Tarot',
                                        key_append = 'vremade_8_ball' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end,
    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = "jackpot",
	loc_txt = {
		name = 'Jackpot',
		text = {
			"If played hand is",
			"a {C:attention}Three of a Kind{},",
			"scoring cards become",
            "{C:attention}Lucky{} cards"
		}
	},
    blueprint_compat = false,
    rarity = 2,
	atlas = 'CMK7CU',
    cost = 6,
    pos = { x = 6, y = 3 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and context.scoring_name == 'Three of a Kind' then
            for _, scored_card in ipairs(context.scoring_hand) do
                scored_card:set_ability('m_lucky', nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        scored_card:juice_up()
                        return true
                    end
                }))
            end
            return {
                message = 'Lucky!',
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker {
    key = "triple_baka",
    loc_txt = {
		name = 'Triple Baka',
		text = {
			"If played hand contains",
			"a {C:attention}Three of a Kind{},",
            "played cards give {X:mult,C:white} X#1# {} Mult",
			"when scored",
            "{C:green}#2# in #3#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
    blueprint_compat = true,
    cost = 8,
    rarity = 2,
    atlas = 'CMK7CU',
    eternal_compat = false,
    pos = { x = 4, y = 3 },
    config = { extra = { Xmult = 2, odds = 900, active = false } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.active } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Three of a Kind']) then
            card.ability.extra.active = true
        elseif context.before and not (next(context.poker_hands['Three of a Kind'])) then
            card.ability.extra.active = false
        end
        if context.individual and context.cardarea == G.play and card.ability.extra.active then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'triple_baka', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end,
    in_pool = function(self, args)
        return (G.GAME.pool_flags.leek_extinct and G.GAME.pool_flags.baguette_extinct and G.GAME.pool_flags.phone_extinct)
    end
}

SMODS.Joker {
    key = "kool_aid",
    loc_txt = {
		name = 'Kool-Aid',
		text = {
			"{X:mult,C:white}X #1#{} Mult,",
            "decreases by {X:mult,C:white}X #2#{} Mult",
			"at end of round"
		}
	},
    blueprint_compat = true,
    eternal_compat = false,
    rarity = 2,
    cost = 6,
    atlas = 'CMK7CU',
    pos = { x = 4, y = 5 },
    config = { extra = { mult_loss = 0.5, xmult =  4} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.mult_loss } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.xmult - card.ability.extra.mult_loss <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.mult_loss
                return {
                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_loss } },
                    colour = G.C.MULT
                }
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end
}

SMODS.Joker {
    key = "pissing_on_the_moon",
	loc_txt = {
		name = 'Pissing on the Moon',
		text = {
			"All played cards with",
			"the {C:clubs}Club{} suit become",
			"{C:gold}Gold{} cards when scored"
		}
	},
    blueprint_compat = false,
    rarity = 2,
	atlas = 'CMK7CU',
    cost = 7,
    pos = { x = 3, y = 0 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_suit("Clubs") then
                    faces = faces + 1
                    scored_card:set_ability('m_gold', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}

SMODS.Joker {
    key = "collision_course",
	loc_txt = {
		name = 'Collision Course',
		text = {
			"Makes {C:attention}Planet{} cards",
			"appear {C:attention}#1#x{} as",
			"often in the shop"
		}
	},
    blueprint_compat = false,
    rarity = 2,
    cost = 7,
	atlas = 'CMK7CU',
    pos = { x = 7, y = 3 },
    config = { extra = { rate = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rate } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.planet_rate = G.GAME.planet_rate * card.ability.extra.rate
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.planet_rate = G.GAME.planet_rate/card.ability.extra.rate
    end
}

SMODS.Joker {
    key = "prianha_plant",
    loc_txt = {
		name = 'Piranha Plant',
		text = {
			"Disables the ability of",
            "the next {C:attention}#1# Boss Blinds{}"
		}
	},
    blueprint_compat = false,
    rarity = 2,
    cost = 9,
    atlas = 'CMK7CU',
    pos = { x = 0, y = 6 },
     config = { extra = { bosses = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.bosses } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            delay(0.4)
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                    card.ability.extra.bosses = card.ability.extra.bosses - 1
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        elseif context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.bosses <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = 'Extinct!',
                    colour = G.C.RED
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            card.ability.extra.bosses = card.ability.extra.bosses - 1
        end
    end
}

SMODS.Joker {
    key = "enchanting_table",
	loc_txt = {
		name = 'Enchanting Table',
		text = {
			"If {C:attention}first hand{} of round is",
			"a {C:attention}single card{}, apply a",
			"random {C:attention}edition{} to it"
		}
	},
    blueprint_compat = false,
    rarity = 3,
    cost = 8,
	atlas = 'CMK7CU',
    pos = { x = 9, y = 2 },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                local edition = SMODS.poll_edition { key = "enchant_table", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
                for _, scored_card in ipairs(context.scoring_hand) do
                    scored_card:set_edition(edition, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
                return {
                message = 'Upgraded!',
                colour = G.C.SECONDARY_SET.Spectral
            }
            end
        end
    end
}

SMODS.Joker {
    key = "seal_of_approval",
	loc_txt = {
		name = 'Seal of Approval',
		text = {
			"If {C:attention}first hand{} of round is",
			"a {C:attention}single card{}, apply a",
			"random {C:attention}seal{} to it"
		}
	},
    blueprint_compat = false,
    rarity = 3,
    cost = 8,
	atlas = 'CMK7CU',
    pos = { x = 5, y = 3 },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.full_hand == 1 and G.GAME.current_round.hands_played == 0 then
                local edition = SMODS.poll_seal { key = "seal_of_approval", guaranteed = true }
                for _, scored_card in ipairs(context.scoring_hand) do
                    scored_card:set_seal(edition, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
                return {
                message = 'Sealed!',
                colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end
    end
}

SMODS.Joker {
    key = "ejection",
	loc_txt = {
		name = 'Ejection',
		text = {
			"If {C:attention}first hand{} of round is",
			"a single {C:attention}Ace{},",
			"destroy it and",
            "level up your",
            "{C:attention}most played hand{}",
            "{C:attention}2{} times",
		}
	},
    blueprint_compat = false,
    rarity = 3,
    cost = 7,
	atlas = 'CMK7CU',
    pos = { x = 3, y = 5 },
    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            if #context.full_hand == 1 and context.destroy_card == context.full_hand[1] and (context.full_hand[1]:get_id() == 14) and G.GAME.current_round.hands_played == 0 then
                local _hand, _tally = nil, nil, 0
                for _, handname in ipairs(G.handlist) do
                    if SMODS.is_poker_hand_visible(handname) and G.GAME.hands[handname].played > _tally then
                        _hand = handname
                        _tally = G.GAME.hands[handname].played
                    end
                end
                if _hand then
                    SMODS.smart_level_up_hand(card, _hand, nil, 2)
                    return {
                        message = localize('k_level_up_ex'),
                        remove = true
                    }
                else
                    SMODS.smart_level_up_hand(card, 'High Card', nil, 2)
                    return {
                        message = localize('k_level_up_ex'),
                        remove = true
                    }
                end
            end
        end
    end
}

SMODS.Joker {
    key = "april_fool",
	loc_txt = {
		name = 'The April Fool',
		text = {
			"Makes {C:attention}Joker{} cards",
			"appear {C:attention}#1#x{} as",
			"often in the shop"
		}
	},
    blueprint_compat = false,
    rarity = 3,
    cost = 8,
	atlas = 'CMK7CU',
    pos = { x = 1, y = 5 },
    config = { extra = { rate = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rate } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_rate = G.GAME.joker_rate * card.ability.extra.rate
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.joker_rate = G.GAME.joker_rate/card.ability.extra.rate
    end
}

SMODS.Joker {
    key = "pearto",
    loc_txt = {
		name = 'Pearto',
		text = {
			"If played hand",
			"contains a {C:attention}Pair{},",
            "level up the",
            "played hand {C:attention}2{} times",
            "{C:green}#1# in #2#{} chance this",
			"card is destroyed",
			"at end of round"
		}
	},
    blueprint_compat = true,
    eternal_compat = false,
    yes_pool_flag = 'pear_extinct',
    rarity = 3,
    cost = 8,
    atlas = 'CMK7CU',
    eternal_compat = false,
    pos = { x = 7, y = 2 },
    config = { extra = { odds = 1024 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Pair']) then
            SMODS.smart_level_up_hand(card, context.scoring_name, nil, 2)
            return {
                message = localize('k_level_up_ex')
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'pearto', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker {
    key = "wiggler",
    loc_txt = {
		name = 'Wiggler',
		text = {
			"{X:mult,C:white}X #1#{} Mult if",
            "played hand contains",
			"a {C:attention}Full House{}"
		}
	},
    blueprint_compat = true,
    cost = 7,
    rarity = 3,
    atlas = 'CMK7CU',
    pos = { x = 5, y = 5 },
    config = { extra = { Xmult = 5} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Full House']) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
    key = "jackin_it",
	loc_txt = {
		name = 'Jackin It',
		text = {
			"This Joker gains {X:mult,C:white} X#2# {} Mult",
			"when a {C:attention}Jack{} is scored",
			"{C:inactive}(Currently {}{X:mult,C:white} X#1# {}{C:inactive} Mult){}"
		}
	},
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 3,
    cost = 8,
	atlas = 'CMK7CU',
    pos = { x = 9, y = 0 },
    config = { extra = { Xmult = 1, Xmult_gain = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_gain } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 11 and not context.blueprint then
            -- See note about SMODS Scaling Manipulation on the wiki
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
    key = "reagonomics",
	loc_txt = {
		name = 'Reagonomics',
		text = {
			"Earn an extra {C:gold}$#1#{} of",
			"{C:attention}interest{} for every {C:gold}$5{} you",
			"have at end of round,",
			"{C:red}self destructs{} if money",
			"falls below {C:gold}$100{}"
		}
	},
    blueprint_compat = false,
    eternal_compat = false,
    rarity = 3,
    cost = 7,
	atlas = 'CMK7CU',
    pos = { x = 7, y = 0 },
    config = { extra = { interest = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.interest } }
    end,
	calculate = function(self, card, context)
		if (context.end_of_round and context.game_over == false) then
        	if (to_number(G.GAME.dollars) < 100) then
            	SMODS.destroy_cards(card, nil, nil, true)
            	return {
                	message = 'Poor!'
            	}
			end
		end
		return
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.interest_amount = G.GAME.interest_amount + card.ability.extra.interest
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.interest_amount = G.GAME.interest_amount - card.ability.extra.interest
    end,
	in_pool = function(self, args) 
		if (to_number(G.GAME.dollars) >= 100) then
            return true
        end
        return false
    end
}

SMODS.Joker {
    key = "thatcherism",
	loc_txt = {
		name = 'Thatcherism',
		text = {
			"Each {C:attention}Gold{} card",
			"held in hand",
			"gives {X:mult,C:white} X#1# {} Mult"
		}
	},
    blueprint_compat = true,
    rarity = 3,
    atlas = 'CMK7CU',
	cost = 7,
    pos = { x = 1, y = 2 },
    config = { extra = { xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and
            (SMODS.has_enhancement(context.other_card, 'm_gold')) then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end,
    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_gold') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = "miku",
	loc_txt = {
		name = 'Hatsune Miku',
		text = {
			"Each played {C:attention}3{} or {C:attention}9{}",
			"gives {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 4, y = 0 },
	soul_pos = {x = 7, y = 1},
    config = { extra = { Xmult = 3.9 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 3 or context.other_card:get_id() == 9) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
    key = "teto",
	loc_txt = {
		name = 'Kasane Teto',
		text = {
			"Each played {C:attention}4{} or {C:attention}Ace{}",
			"gives {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 0, y = 1 },
	soul_pos = { x = 5, y = 1 },
    config = { extra = { Xmult = 4.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 4 or context.other_card:get_id() == 14) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
    key = "neru",
	loc_txt = {
		name = 'Akita Neru',
		text = {
			"Create a {C:spectral}Spectral{} card",
			"when {C:attention}Blind{} is selected",
			"{C:inactive}(Must have room){}"

		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 1, y = 1 },
	soul_pos = { x = 4, y = 1 },
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Spectral',
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end
}

SMODS.Joker {
    key = "gumi",
	loc_txt = {
		name = 'GUMI',
		text = {
			"Each {C:attention}Queen{}",
			"held in hand",
			"gives {X:mult,C:white} X#1# {} Mult"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 6, y = 0 },
	soul_pos = {x = 6, y = 1},
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 12 then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra.xmult
                }
            end
        end
    end
}

SMODS.Joker {
    key = "rei",
	loc_txt = {
		name = 'Adachi Rei',
		text = {
			"Played {C:attention}Steel{} cards",
			"give {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 0, y = 3 },
	soul_pos = { x = 1, y = 3},
    config = { extra = { Xmult = 2.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (SMODS.has_enhancement(context.other_card, 'm_steel')) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
    key = "rin",
	loc_txt = {
		name = 'Kagamine Rin',
		text = {
			"Each played {C:attention}2{}",
			"gives {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 3, y = 1 },
	soul_pos = { x = 8, y = 1},
    config = { extra = { Xmult = 2.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 2) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker {
	key = 'len',
	loc_txt = {
		name = 'Kagamine Len',
		text = {
			"Retrigger each played",
			"{C:attention}2{} an additional {C:attention}#1#{} times",
		}
	},
	config = { extra = { repetitions = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
	rarity = "cmk7_diva",
	atlas = 'CMK7CU',
	pos = { x = 2, y = 1 },
	soul_pos = { x = 9, y = 1},
	cost = 25,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card:get_id() == 2 then
				return {
					--message = 'Again!',
					repetitions = card.ability.extra.repetitions--,
					--card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
    key = "kaito",
	loc_txt = {
		name = 'KAITO',
		text = {
			"Gains {X:mult,C:white} X#1# {} Mult",
            "for each consecutive hand whilst",
            "playing your {C:attention}most played hand{}",
			"{C:inactive}(Currently {}{X:mult,C:white} X#2# {}{C:inactive} Mult){}"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    atlas = 'CMK7CU',
	cost = 25,
    pos = { x = 9, y = 4 },
	soul_pos = { x = 8, y = 4 },
    config = { extra = { Xmult_gain = 0.2, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local reset = false
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for handname, values in pairs(G.GAME.hands) do
                if handname ~= context.scoring_name and values.played >= play_more_than and SMODS.is_poker_hand_visible(handname) then
                    reset = true
                    break
                end
            end
            if reset then
                if card.ability.extra.Xmult > 1 then
                    card.ability.extra.Xmult = 1
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                -- See note about SMODS Scaling Manipulation on the wiki
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

SMODS.Joker {
    key = "meiko",
    loc_txt = {
		name = 'MEIKO',
		text = {
			"{C:attention}+#1#{} hand size"
		}
	},
    blueprint_compat = false,
    rarity = "cmk7_diva",
    cost = 25,
    atlas = "CMK7CU",
    pos = { x = 9, y = 5 },
    soul_pos = { x = 8, y = 5},
    config = { extra = { h_size = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end
}

SMODS.Joker {
    key = "luka",
    loc_txt = {
		name = 'Megurine Luka',
		text = {
			"When {C:attention}Blind{} is selected,",
            "create {C:attention}#1#{} {C:rare}Rare{}, {C:legendary}Legendary{},",
            "or {C:cmk7_diva}Diva{} {C:attention}Joker{}",
            "{C:inactive}(Must have room){}"            
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_diva",
    cost = 25,
    atlas = 'CMK7CU',
    pos = { x = 2, y = 5 },
    soul_pos = { x = 7, y = 5},
    config = { extra = { creates = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.creates } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(card.ability.extra.creates,
                G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    local rar = 'Rare'
                    for _ = 1, jokers_to_create do
                        if SMODS.pseudorandom_probability(card, 'luka', 1, 20) then
                            rar = 'cmk7_diva'
                        elseif SMODS.pseudorandom_probability(card, 'luka', 1, 10) then
                            rar = 'Legendary'
                        else
                            rar = 'Rare'
                        end
                        SMODS.add_card {
                            set = 'Joker',
                            rarity = rar,
                            key_append = 'luka' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end
            }))
            return {
                message = localize('k_plus_joker'),
                colour = G.C.BLUE,
            }
        end
    end,
}

SMODS.Joker {
    key = "arch",
    loc_txt = {
		name = 'Arch Linux',
		text = {
			"{C:attention}+#1#{} consumable slots"
		}
	},
    blueprint_compat = false,
    rarity = "cmk7_linux",
    atlas = 'CMK7CU',
	cost = 15,
    pos = { x = 0, y = 4 },
	soul_pos = { x = 5, y = 4 },
	config = { extra = { exSlots = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.exSlots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.exSlots
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.exSlots
                return true
            end
        }))
    end
}

SMODS.Joker {
    key = "debian",
	loc_txt = {
		name = 'Debian',
		text = {
			"Makes {C:spectral}Spectral{} cards",
			"appear in the shop",
            "{C:inactive}({}{C:attention}#2#x{} {C:inactive}appearance rate{}",
			"{C:inactive}on {}{C:attention}Ghost Deck{}{C:inactive}){}"
		}
	},
    blueprint_compat = false,
    rarity = "cmk7_linux",
    atlas = 'CMK7CU',
	cost = 15,
    pos = { x = 2, y = 4 },
	soul_pos = { x = 3, y = 4 },
    config = { extra = { rate = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rate, (card.ability.extra.rate * 2) } }
    end,
    add_to_deck = function(self, card, from_debuff)
        if (G.GAME.spectral_rate == 0) then
            G.GAME.spectral_rate = G.GAME.spectral_rate + card.ability.extra.rate
        else
            G.GAME.spectral_rate = G.GAME.spectral_rate * (card.ability.extra.rate * 2)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if (G.GAME.spectral_rate == 2) then
            G.GAME.spectral_rate = G.GAME.spectral_rate - card.ability.extra.rate
        else
            G.GAME.spectral_rate = G.GAME.spectral_rate/(card.ability.extra.rate * 2)
        end
    end
}

SMODS.Joker {
    key = "fedora",
	loc_txt = {
		name = 'Fedora',
		text = {
			"Each played card of",
            "{C:clubs}Club{} or {C:spades}Spade{} suit",
            "gives {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_linux",
    atlas = 'CMK7CU',
	cost = 15,
    pos = { x = 1, y = 4 },
	soul_pos = { x = 4, y = 4 },
    config = { extra = { Xmult = 1.43 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:is_suit("Clubs") or context.other_card:is_suit("Spades")) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}

SMODS.Joker {
    key = "mint",
	loc_txt = {
		name = 'Linux Mint',
		text = {
			"{C:attention}+#1#{} card and",
			"booster pack slot",
            "avaliable in the shop"
		}
	},
    blueprint_compat = false,
    rarity = "cmk7_linux",
    atlas = 'CMK7CU',
	cost = 15,
    pos = { x = 8, y = 3 },
	soul_pos = { x = 6, y = 4 },
	config = { extra = { exSlots = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.exSlots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(card.ability.extra.exSlots)
                return true
            end
        }))
        SMODS.change_booster_limit(card.ability.extra.exSlots)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(-card.ability.extra.exSlots)
                return true
            end
        }))
        SMODS.change_booster_limit(-card.ability.extra.exSlots)
    end
}

SMODS.Joker {
    key = "ubuntu",
	loc_txt = {
		name = 'Ubuntu',
		text = {
			"Each played {C:attention}4{} or {C:attention}10{}",
			"gives {X:mult,C:white} X#1# {} Mult",
			"when scored"
		}
	},
    blueprint_compat = true,
    rarity = "cmk7_linux",
    atlas = 'CMK7CU',
	cost = 15,
    pos = { x = 9, y = 3 },
	soul_pos = { x = 7, y = 4 },
    config = { extra = { Xmult = 2.04 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 4 or context.other_card:get_id() == 10) then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

