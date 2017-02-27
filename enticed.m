function decide_to_hit = enticed(dealer, player, usable_ace, policy)
if policy(player - 11, dealer, usable_ace + 1)
    decide_to_hit = true;
else
    decide_to_hit = false;
end
end