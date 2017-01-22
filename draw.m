function [cards, deck] = draw(deck, number_of_draws)

cards = [];
for ii = 1:number_of_draws
    found = false;
    while ~found
        card_drawn = randi([1 13]);
        if deck(card_drawn) > 0
            if card_drawn > 10
                card_drawn = 10;
            end
            cards = [cards; card_drawn];
            deck(card_drawn) = deck(card_drawn) - 1;
            found = true;
        end
    end
end
end