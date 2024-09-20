module metaschool::RockPaperScissors_04 {
    use std::string::{String,utf8};
    use std::signer;
    use aptos_framework::randomness;

    struct DuelResult has key
    {
        computer_selection: String,
        duel_result: String
    }

    public entry fun createGame(account: &signer)acquires DuelResult { 
        if (exists<DuelResult>(signer::address_of(account))){
            let result = borrow_global_mut<DuelResult>(signer::address_of(account));
            result.computer_selection = utf8(b"New Game Created");  
            result.duel_result = utf8(b"Game not yet played");
        }
        else {
            let result = DuelResult { computer_selection: utf8(b"New Game Created") , duel_result:utf8(b"Game not yet played")};
            move_to(account, result);
        }
    }

    public fun get_result(account: &signer): (String, String) acquires DuelResult {
        let result = borrow_global<DuelResult>(signer::address_of(account));
        (result.computer_selection, result.duel_result)
    }

    #[randomness]
    entry fun duel(account: &signer, user_selection: String) acquires DuelResult {
        let random_number = randomness::u64_range(0, 3); // 3 is exclusive
        let result = borrow_global_mut<DuelResult>(signer::address_of(account));
        if(random_number==0)
        {
            result.computer_selection = utf8(b"Rock");
        }
        else
        {
            if(random_number==1)
            {
                result.computer_selection = utf8(b"Paper");
            }
            else
            {
                result.computer_selection = utf8(b"Scissors");
            }
        };

        let computer_selection = &result.computer_selection;

        if (user_selection == *computer_selection) {
            result.duel_result = utf8(b"Draw"); // Draw
        } else if ((user_selection == utf8(b"Rock") && *computer_selection == utf8(b"Scissors")) ||
                   (user_selection == utf8(b"Paper") && *computer_selection == utf8(b"Rock")) ||
                   (user_selection == utf8(b"Scissors") && *computer_selection == utf8(b"Paper"))) {
            result.duel_result = utf8(b"Win"); // User wins
        } else {
            result.duel_result = utf8(b"Lose"); // Computer wins
        }
    }
}
