function decide_to_hit = enticed(dealer, player, usable_ace, policy)
if policy(player, dealer, usable_ace)
    decide_to_hit = true;
else
    decide_to_hit = false;
end
end