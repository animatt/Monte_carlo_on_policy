function decide_to_hit = enticed(dealer, player, usable_ace, policy)
if policy(player - 11, dealer - 1, usable_ace)
    decide_to_hit = true;
else
    decide_to_hit = false;
end
end