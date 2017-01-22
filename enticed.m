function val = enticed(dealer, player)
if sum(player) < 17 && sum(player) ~= 21
    val = true;
else
    val = false;
end
end