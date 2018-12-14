pragma solidity ^0.4.24;

contract TicTacToe {
    
    /* state variables */
    struct Player {
        string name;
        uint256 deposit;
        uint8 move;
        uint8 index;
    }
    
    uint256 noPlayers=0;
    uint8 private turn=0;
    uint256 private moveCount=0;
    bool private Game=true;
    string private winnerName;
    mapping (address=>Player) playerSet;
    uint256 private balance;
    
    mapping (uint8=> mapping (uint8=>uint8)) gameBoard; // defining the game board; 1 represents x and 2 represents o
    
    event GameWinner(string name);
    
    /* condition checks */
    modifier gameNotOver () {
        require(Game==true, "Game is already over");
        _;
    }
    
    modifier gameOver () {
        require(Game==false, "Game is Not over yet");
        _;
    }
    
    modifier turnCheck (address _add, uint8 _turn) {
        require(playerSet[_add].index==_turn, "Not this players turn");
        _;
    }
    
    modifier playerCount () {
        require(noPlayers<2, "More players cannot be registered");
        _;
    }
    
    modifier validMove (uint8 x, uint8 y) {
        require (gameBoard[x][y]!=1 && gameBoard[x][y]!=2, "Move is invalid");
        _;
    }
    
    modifier playerExists (address _add) {
        require (playerSet[_add].deposit!=0, "Player does not exist");
        _;
    }
    /* Game functions */
    
    function registerPlayer (string memory s, uint256 token) public payable playerCount() {
        noPlayers=noPlayers+1;
        playerSet[msg.sender].name=s;
        playerSet[msg.sender].deposit=token;
        balance+=msg.value;
        if (noPlayers==1) {
            playerSet[msg.sender].index=1;
            playerSet[msg.sender].move=1;
        }
        else {
            playerSet[msg.sender].index=2;
            playerSet[msg.sender].move=2;
        }
        turn=1;
        return;
    }
    
    function registerMove (uint8 x, uint8 y) public turnCheck(msg.sender, turn) gameNotOver() validMove(x,y) {
        gameBoard[x][y]=playerSet[msg.sender].move;
        moveCount=moveCount+1;
        if (moveCount%2==0) { // index 1 will now play
            turn=1;
        }
        else { // index 2 turn to play
            turn=2;
        }
        // now check whether this move results in a winner
        checkWinner();
        return;
    }
    
    function checkWinner () private {
        /*
        // check diagonals
        if (((gameBoard[0][0]==gameBoard[1][1] && gameBoard[1][1]==gameBoard[2][2]) || (gameBoard[0][2]==gameBoard[1][1] && gameBoard[1][1]==gameBoard[2][0]))&& gameBoard[0][0]!=0 && gameBoard[0][1]!=0 && gameBoard[0][2]!=0) {
            winnerName=playerSet[msg.sender].name;
            Game=false;
            emit GameWinner(winnerName);
            return;
        }
        // check rows
        if (((gameBoard[0][0]==gameBoard[0][1] && gameBoard[0][1]==gameBoard[0][2]) || (gameBoard[1][0]==gameBoard[1][1] && gameBoard[1][1]==gameBoard[1][2]) || (gameBoard[2][0]==gameBoard[2][1] && gameBoard[2][1]==gameBoard[2][2])) && gameBoard[0][0]!=0 && gameBoard[0][1]!=0 && gameBoard[0][2]!=0) {
            winnerName=playerSet[msg.sender].name;
            Game=false; 
            emit GameWinner(winnerName);
            return;
        }
        // check columns
        if (((gameBoard[0][0]==gameBoard[1][0] && gameBoard[1][0]==gameBoard[2][0]) || (gameBoard[0][1]==gameBoard[1][1] && gameBoard[1][1]==gameBoard[2][1]) || (gameBoard[0][2]==gameBoard[1][2] && gameBoard[1][2]==gameBoard[2][2])) && gameBoard[0][0]!=0 && gameBoard[0][1]!=0 && gameBoard[0][2]!=0) {
            winnerName=playerSet[msg.sender].name;
            Game=false; 
            emit GameWinner(winnerName);
            return;
        }
        */
        
        if (gameBoard[0][0]==gameBoard[1][0] && gameBoard[1][0]==gameBoard[2][0] && gameBoard[0][0]==1) {
            winnerName=playerSet[msg.sender].name;
            Game=false; 
            emit GameWinner(winnerName);
            return;
        }
        
        // check for draw
        if (moveCount==9) {
            Game=false;
            emit GameWinner("Draw");
            return;
        }
    }
    
    function returnDeposit() public payable gameOver() {
        balance-=playerSet[msg.sender].deposit;
        msg.sender.transfer(playerSet[msg.sender].deposit);
    } 
    
 
    
}
