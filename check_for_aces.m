function cards = check_for_aces(cards)
if sum(cards) < 11
    I = find(cards == 1);
    if length(I) ~= 0
        cards(I(1)) = 11;
    end
end
end