pragma solidity ^0.6.0;

contract LCR {
    // Players in the game
    address[] public players;

    // Number of chips each player has
    mapping (address => uint) public chips;

    // The player who is currently taking their turn
    address public currentPlayer;

    // The number of chips in the center pot
    uint public centerPot;

    constructor() public {
        // Initialize the center pot with 3 chips
        centerPot = 3;
    }

    // Function to join the game
    function joinGame() public {
        // Add the caller to the list of players
        players.push(msg.sender);

        // Give the player 3 chips
        chips[msg.sender] = 3;

        // Set the current player to the first player
        currentPlayer = players[0];
    }

    // Function to play the game
    function play(string memory direction) public {
        // Check if the caller is the current player
        require(msg.sender == currentPlayer, "It is not your turn.");

        // Check if the direction is valid
        require(
            direction == "left" || direction == "center" || direction == "right",
            "Invalid direction."
        );

        // Check if the player has any chips
        require(chips[msg.sender] > 0, "You have no chips to play.");

        // Deduct one chip from the current player
        chips[msg.sender]--;

        // If the direction is "left", pass one chip to the player on the left
        if (direction == "left") {
            uint leftIndex = players.indexOf(currentPlayer) - 1;
            if (leftIndex < 0) {
                leftIndex = players.length - 1;
            }
            address leftPlayer = players[leftIndex];
            chips[leftPlayer]++;
        }
        // If the direction is "center", add one chip to the center pot
        else if (direction == "center") {
            centerPot++;
        }
        // If the direction is "right", pass one chip to the player on the right
        else if (direction == "right") {
            uint rightIndex = players.indexOf(currentPlayer) + 1;
            if (rightIndex >= players.length) {
                rightIndex = 0;
            }
            address rightPlayer = players[rightIndex];
            chips[rightPlayer]++;
        }

        // Move to the next player
        currentPlayer = players[(players.indexOf(currentPlayer) + 1) % players.length];
    }
}
