function decide_to_hit = enticed(dealer, player, policy)
if policy(dealer, player)
    decide_to_hit = true;
else
    decide_to_hit = false;
end
end