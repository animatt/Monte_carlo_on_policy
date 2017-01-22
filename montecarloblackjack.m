clear; clc; close all;

%Optimal policy for blackjack using monte carlo

dealer_blackjack = false;
player_blackjack = false;

count = 0;
while count < 1
    count = count + 1;
    deck = 4 * ones(13, 1);
    
    %dealer draws two cards
    [dealers_cards, deck] = draw(deck, 2);
    dealers_cards = check_for_aces(dealers_cards);
    dealer_faceup = dealers_cards(1)
    
    %player receives his own two cards
    [players_cards, deck] = draw(deck, 2);
    players_cards = check_for_aces(players_cards)
    
    neither_have_busted = true;
    dealer_blackjack = false;
    player_blackjack = false;
    
    if sum(dealers_cards) == 21
        dealer_blackjack = true;
    end
    
    if sum(players_cards) == 21
        player_blackjack = true;
    end
    
    if player_blackjack || dealer_blackjack
        if player_blackjack && ~dealer_blackjack
            fprintf('You win with an opening blackjack\n')
            % reward += 1
            continue
        elseif ~player_blackjack && dealer_blackjack
            fprintf('Dealer wins with an opening blackjack\n')
            % reward -= 1
            continue
        else
            fprintf('Opening draw')
            % reward += 0
            continue
        end
    end
        
    
    players_turn = true;
    while players_turn && neither_have_busted
        if enticed(dealer_faceup, players_cards)
            [new_card, deck] = hit(deck);
            players_cards = check_for_aces([players_cards; new_card]);
            
            if sum(players_cards) > 21
                neither_have_busted = false;
                fprintf('You busted.\n')
            end
        else
            players_turn = false;
        end
    end
    
    dealers_turn = true;
    while dealers_turn && neither_have_busted
        
        if sum(dealers_cards) <= sum(players_cards) && sum(dealers_cards) ~= 21
            [new_card, deck] = hit(deck);
            dealers_cards = [dealers_cards; new_card];
            
            if sum(dealers_cards) > 21
                neither_have_busted = false;
                fprintf('Dealer busts. You win\n')
                
            % check if dealer has blackjack but player does not
            elseif sum(dealers_cards) == 21
                if sum(players_cards) == 21
                    fprintf('The game is a draw\n')
                    dealers_turn = false;
                    % reward += 0
                else
                    fprintf('Dealer''s blackjack. You lose\n')
                    % reward -= 1
                    dealers_turn = false;
                end
            end
        else
            fprintf('Dealer''s hand wins\n')
            dealers_turn = false;
        end
    end
    
end
%for list of rules
%http://wizardofodds.com/games/blackjack/basics/

%to-do: overload sum function to account for aces, modify to accomodate
%both human and ai players