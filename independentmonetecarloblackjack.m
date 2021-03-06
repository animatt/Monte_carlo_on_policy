clear, clc, close all

% Blackjack from an infinite boot. This is a simplified version of the
% blackjack program in montecarloblackjack.m based on the example given in
% chapter 5 of Introduction to Reinforcement Learning, RS Sutton that uses
% the Monte Carlo ES algorithm to determine an optimal policy.

deck = 4 * ones(13, 1);

% (player, dealer, useable_ace[, action])
returns = zeros(9, 10, 2, 2);
visits = zeros(9, 10, 2, 2);
policy = zeros(9, 10, 2);
Qsa = zeros(9, 10, 2, 2);

while converging
    % game loop
    neither_have_busted = true;
    episode_history = [];
    
    %generate initial state
    dealers_faceup = randi([1 10]);
    dealers_ace = isace(dealers_faceup);
    dealers_cards = dealers_faceup + 10 * dealers_ace;
    
    usable_ace = randi([0 1]);
    players_cards = randi([12 20]);
    first_action = [randi([0 1]) 1]; % randomly hit or stick

    % begin game
    players_turn = true;
    while players_turn && neither_have_busted
        
        if (enticed(dealers_faceup, players_cards, usable_ace, policy)...
                && ~first_action(2)) || (first_action(1) && first_action(2))
            [new_card, ~] = hit(deck);
            
            episode_history = [episode_history; players_cards usable_ace 1];
            
            players_cards = new_card + players_cards;
            
            if players_cards > 21
                if usable_ace
                    players_cards = players_cards - 10;
                    usable_ace = 0;
                else
                    neither_have_busted = false;
                end
            elseif players_cards == 21
                players_turn = false;
            end
        else
            episode_history = [episode_history; players_cards usable_ace 0];
            players_turn = false;
        end
        first_action(2) = 0;
    end
    
    dealers_turn = true;
    while dealers_turn && neither_have_busted
        if dealers_cards <= 16
            [new_card, ~] = hit(deck);
            
            dealers_ace = dealers_ace || isace(new_card);
            
            dealers_cards = dealers_cards + new_card ...
                + 10 * isace(new_card) * (dealers_cards <= 11);
            if dealers_cards > 21
                if dealers_ace
                    dealers_cards = dealers_cards - 10;
                    dealers_ace = 0;
                else
                    neither_have_busted = false;
                end
            elseif dealers_cards == 21
                dealers_turn = false;
            end
        else
            dealers_turn = false;
        end
    end
    
    % state action pairs
    one = ones(size(episode_history, 1), 1);
    
    sa = sub2ind(size(returns), episode_history(:, 1) - 11, ...
        dealers_faceup * one, episode_history(:, 2) + 1, ...
        episode_history(:, 3) + 1); 
    
    % determine winner
    if neither_have_busted
        if players_cards > dealers_cards
            returns(sa) = returns(sa) + 1;
        elseif players_cards < dealers_cards
            returns(sa) = returns(sa) - 1;
        else
            % draw
        end
    elseif players_cards <= 21 % dealer busted
        returns(sa) = returns(sa) + 1;
    else % player busted
        returns(sa) = returns(sa) - 1;
    end
    
    visits(sa) = visits(sa) + 1;
    
    % improve state action value approx.
    Qsa(sa) = returns(sa) ./ visits(sa);
    % improve policy
    policy = Qsa(:, :, :, 2) > Qsa(:, :, :, 1);
end
