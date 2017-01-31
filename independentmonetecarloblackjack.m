clear, clc, close all

% Blackjack from an infinite boot. This is a simplified version of the
% blackjack program in montecarloblackjack.m based on the example given in
% chapter 5 of Introduction to Reinforcement Learning, RS Sutton.

deck = 4 * ones(13, 1);
reward = [];

while converging
    % game loop
    blackjack = false;
    neither_have_busted = true;
    
    [dealers_cards, ~] = draw(deck, 2);
    dealers_faceup = dealers_cards(1);
    
    [player_cards, ~] = draw(deck, 2);
    while sum(players_cards) <= 11
        [players_cards, ~] = hit(deck);
    end
    
    if sum(players_cards) == 21 || sum(dealers_cards) == 21
        blackjack = true;
    end
    
    if blackjack
        if sum(players_cards) == sum(dealers_cards)
            % reward = reward
        elseif sum(players_cards) > sum(dealers_cards)
            reward = reward + 1;
        else
            reward = reward - 1;
        end
        continue
    end
    
    % begin game
    players_turn = true;
    while players_turn && neither_have_busted
        if enticed(dealers_cards, sum(players_cards))
            [players_cards, ~] = hit(deck);
            if sum(players_cards) > 21
                neither_have_busted = false;
            elseif sum(players_cards) == 21
                blackjack = true;
                players_turn = false;
            end
        else
            players_turn = false;
        end
    end
    
    dealers_turn = true;
    while dealers_turn && neither_have_busted
        if sum(dealers_cards) < 21 && sum(dealers_cards) <= sum(players_cards)
            [dealers_cards, ~] = hit(deck);
            if sum(dealers_cards) > 21
                neither_have_busted = false;
            elseif sum(dealers_cards) == 21
                blackjack = true;
            end
        else
            dealers_turn = false;
        end
    end
    
    % determine winner
    if neither_have_busted
        if blackjack
            if sum(players_cards) == sum(dealers_cards)
                % reward = reward
            elseif sum(players_cards) > sum(dealers_cards)
                reward = reward + 1;
            else
                reward = reward - 1;
            end
        else % dealer won
            reward = reward - 1;
        end
    elseif sum(players_cards) <= 21 % player won
        reward = reward + 1;
    else % dealer won
        reward = reward - 1;
    end
end
