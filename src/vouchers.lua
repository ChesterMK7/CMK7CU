SMODS.Voucher {
    key = 'the_rich_get_richer',
    loc_txt = {
        name = "The Rich Get Richer",
        text ={
            "Raise the cap on",
            "interest earned in",
            "each round to {C:gold}$#2#{}"
        },
    },
    pos = { x = 1, y = 3 },
    config = { extra = { cap = 250 } },
    unlocked = true,
    requires = { 'v_money_tree' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cap, (card.ability.extra.cap/5) } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.interest_cap = card.ability.extra.cap
                return true
            end
        }))
    end
}
