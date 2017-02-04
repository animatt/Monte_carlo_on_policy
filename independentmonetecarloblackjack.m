clear, clc, close all

% Blackjack from an infinite boot. This is a simplified version of the
% blackjack program in montecarloblackjack.m based on the example given in
% chapter 5 of Introduction to Reinforcement Learning, RS Sutton that uses
% the Monte Carlo ES algorithm to determine an optimal policy.

deck = 4 * ones(13, 1);

returns = zeros(9, 2, 2);
visits = zeros(9, 2, 2);
policy = ones(9, 2);
Qsa = zeros(9, 2, 2);

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
        S_t = sum(players_cards);
        
        if (enticed(dealers_faceup, sum(players_cards), policy) ...
                && first_action(2)) || (first_action(1) && first_action(2))
            [players_cards, ~] = hit(deck);
            
            episode_history = [episode_history; S_t 1];
            
            if sum(players_cards) > 21
                neither_have_busted = false;
            elseif sum(players_cards) == 21
                blackjack = true;
                players_turn = false;
            end
        else
            episode_history = [episode_history; S_t 0];
            players_turn = false;
        end
        first_action(2) = 0;
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
    
    
    sa = sub2ind(size(returns), episode_history(:, 1), ...
        usable_ace, episode_history(:, 2)); % state action pairs
    
    % determine winner
    if neither_have_busted
        if blackjack && sum(players_cards) == sum(dealers_cards)
            % draw
        else
            returns(sa) = returns(sa) - 1;
        end
    elseif sum(players_cards) <= 21 % dealer busted
        returns(sa) = returns(sa) + 1;
    else % player busted
        returns(sa) = returns(sa) - 1;
    end
    
    visits(sa) = visits(sa) + 1;
    
    % improve state action value approx.
    Qsa(sa) = ((visits(sa) - 1) .* Q(sa) + returns(sa)) ./ visits(sa);
    % improve policy
    policy(:, usable_ace) = max(Qsa(:, usable_ace, :), 3);
end
