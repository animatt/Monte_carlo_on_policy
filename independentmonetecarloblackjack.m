clear, clc, close all

% Blackjack from an infinite boot. This is a simplified version of the
% blackjack program in montecarloblackjack.m based on the example given in
% chapter 5 of Introduction to Reinforcement Learning, RS Sutton that uses
% the Monte Carlo ES algorithm to determine an optimal policy.

deck = 4 * ones(13, 1);

% (player, dealer, useable_ace[, action])
returns = zeros(9, 10, 2, 2);
visits = zeros(9, 10, 2, 2);
policy = ones(9, 10, 2);
Qsa = zeros(9, 10, 2, 2);

while converging
    % game loop
    blackjack = false;
    neither_have_busted = true;
    episode_history = [];
    
    %generate initial state
    dealers_faceup = randi([2 11]);
    usable_ace = randi([1 2]);
    players_cards = randi([12 20]);
    first_action = [randi([0 1]) 1]; % randomly hit or stick

    % begin game
    players_turn = true;
    while players_turn && neither_have_busted
        
        if (enticed(dealers_faceup, players_cards, usable_ace, policy)...
                && first_action(2)) || (first_action(1) && first_action(2))
            [new_card, ~] = hit(deck);
            
            episode_history = [episode_history; players_cards 1];
            
            players_cards = new_card + players_cards;
            
            if players_cards > 21
                neither_have_busted = false;
            elseif players_cards == 21
                blackjack = true;
                players_turn = false;
            end
        else
            episode_history = [episode_history; players_cards 0];
            players_turn = false;
        end
        first_action(2) = 0;
    end
    
    dealers_cards = dealers_faceup;
    
    dealers_turn = true;
    while dealers_turn && neither_have_busted
        if dealers_cards < 21 && dealers_cards <= players_cards
            [new_card, ~] = hit(deck);
            dealers_cards = dealers_cards + new_card;
            if dealers_cards > 21
                neither_have_busted = false;
            elseif dealers_cards == 21
                blackjack = true;
            end
        else
            dealers_turn = false;
        end
    end
    
    % state action pairs
    one = ones(size(episode_history, 1), 1);
    sa = sub2ind(size(returns), episode_history(:, 1) - 11, ...
        (dealers_faceup - 1) * one, usable_ace * one, ...
        episode_history(:, 2) + 1); 
    
    
    % determine winner
    if neither_have_busted
        if blackjack && players_cards == dealers_cards
            % draw
        else
            returns(sa) = returns(sa) - 1;
        end
    elseif players_cards <= 21 % dealer busted
        returns(sa) = returns(sa) + 1;
    else % player busted
        returns(sa) = returns(sa) - 1;
    end
    
    visits(sa) = visits(sa) + 1;
    
    % improve state action value approx.
    Qsa(sa) = ((visits(sa) - 1) .* Qsa(sa) + returns(sa)) ./ visits(sa);
    % improve policy
    policy(:, dealers_cards, usable_ace) = ...
        max(Qsa(:, dealers_cards, usable_ace, :), [], 4);
end
