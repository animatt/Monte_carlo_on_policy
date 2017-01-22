clear; clc; close all;

%Optimal policy for blackjack using monte carlo

while converging(condition)
    deck = 4 * ones(13, 1);
    
    %dealer draws two cards
    [dealers_cards, deck] = draw(deck, 2);
    dealers_cards = check_for_aces(dealers_cards);
    dealer_faceup = dealers_cards(1)
    
    %player receives his own two cards
    [players_cards, deck] = draw(deck, 2);
    players_cards = check_for_aces(players_cards)
    
    neither_have_busted = true;
    player_busted = false;
    dealer_busted = false;
    
    
    if sum(dealers_cards) == 21 || sum(players_cards) == 21
        if sum(players_cards) == 21
            fprintf('It was a draw')
            
            % reward of 0
            continue
        else
            
        end
        players_turn = true;
        while players_turn && neither_have_busted
            if enticed(dealer_faceup, players_cards)
                [new_card, deck] = hit(deck);
                players_cards = check_for_ace([players_cards; new_card]);
                
                if sum(players_cards) > 21
                    neither_have_busted = false;
                    player_busted = true;
                    fprintf('You busted.\n')
                end
            else
                players_turn = false;
            end
        end
        
        dealers_turn = true;
        while dealers_turn && neither_have_busted
            if sum(dealers_cards) <= sum(players_cards) && sum(dealers_cards ~= 21)
                [new_card, deck] = hit(deck);
                dealers_cards = [dealers_cards; new_card];
                
                if sum(dealers_cards) > 21
                    neither_have_busted = false;
                    dealer_busted = true;
                    fprintf('Dealer busts. You win\n')
                end
            else
                fprintf('Dealer''s hand wins\n')
                dealers_turn = false;
            end
        end
        
    end
    fprintf('done\n')
    %for list of rules
    %http://wizardofodds.com/games/blackjack/basics/
    
    %to-do: overload sum function to account for aces, modify to accomodate
    %both human and ai players