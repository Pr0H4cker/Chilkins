options:
    min: 500    # Minimum bounty amount
    pre: &3&l(BOUNTY)  # Prefix for messages

command /bounty [<offline player>] [<number>]:
    trigger:
        if arg-1 is set:
            if arg-2 is set:
                if arg-2 >= {@min}:
                    if {balance::%uuid of player%} >= arg-2:    # I use {balance::%uuid of player%} as money. feel free to change it to "player's balance"
#                        arg-1 is not player (If you don't want players to put the bounty on themselves, remove the # at the start of the line.)
                        add argument 1 to {bounty::list::*} if {bounty::list::*} does not contain arg-1
                        add argument 2 to {bounty::%uuid of arg-1%}
                        remove argument 2 from {balance::%uuid of player%}
                        send "{@pre} &7A bounty of &b%arg-2%$ &7has been placed on &b%arg-1% by &b%player%" to all players
                    else:
                        send "{@pre} &7You do not have enough money to place a bounty."
                else:
                    send "{@pre} &7The minimum bounty amount is &b{@min}&7."
            else:
                send "{@pre} &7Please provide an amount."
        else:
            send "{@pre} &7Please provide a player."

on death of player:
    if attacker is a player: 
        if {bounty::list::*} contains victim:
            set {_bounty} to ("%{bounty::%uuid of victim%}%" parsed as number)
            add {_bounty} to {balance::%uuid of attacker%}
            broadcast "{@pre} &b%attacker% &7just claimed &b%victim%&7's bounty of &b%{_bounty}%$&7..."
            remove victim from {bounty::list::*}
            delete {bounty::%uuid of victim%}
        
        # Kill System
        add 1 to {kills::%uuid of attacker%}    # Assuming {kills::%uuid of attacker%} is your kills variable... (Change if you want..)
        add 1 to {deaths::%uuid of victim%}     # Assuming {deaths::%uuid of victim%} is your deaths variable... (Change if you want..)

        # KDR System (Remove if you want..)
        set {KDR::%uuid of attacker%} to KDR(attacker) # Assuming {KDR::%uuid of attacker%} is your variable for KDR (Change if you want.)
        set {KDR::%uuid of victim%} to KDR(victim)


# This KDR Function is not mine. This is BennyDoesStuff's KDR Function.

function KDR(p: player) :: number:
    set {_u} to uuid of {_p}
    if {kills::%{_u}%} != 0:
        if {deaths::%{_u}%} != 0:
            return {kills::%{_u}%} / {deaths::%{_u}%}
        else:
            return {kills::%{_u}%}
    else:
        return 0


# Bounties (See the players with bounties!)

command /bounties [<text>]:
    trigger:
        page(player, 0)

function page(p: player, page: number):
    set {_pageStart} to 45*{_page}
    set {_i} to 1
    set {_a} to 0
    open virtual chest inventory with size 6 named "&b&lBOUNTY &7List &f&oPage %{_page} + 1%" to {_p}
    wait 2 ticks
    loop {bounty::list::*}:
        (loop-index parsed as integer) > {_pageStart}
        set {_player} to loop-value
        set {_u} to uuid of {_player}
        format gui slot {_a} of {_p} with skull of ("%{_player}%" parsed as offline player) named "&7%{_player}%" with lore "&7Bounty &8- &b%{bounty::%{_u}%}%" to do nothing
        add 1 to {_a}
        if {_a} = ((45*{_i})):
            exit loop
    format gui slot 49 of {_p} with book named "&eMain Page" to run:
        page({_p}, 0)
    if (amount of {tuber::videos::%{_u}%::*}) > {_pageStart} + 45:
        
        format gui slot 53 of {_p} with arrow named "&9Next Page" to run:
            set {_page} to {_page} + 1
            page({_p}, {_page})
    if {_page} > 0:
        format gui slot 45 of {_p} with arrow named "&9Previous Page" to run:
            set {_page} to {_page} - 1
            page({_p}, {_page})
