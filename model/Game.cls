/// Controls the overall instance of a game, between two players with two grids each
Class btships.model.Game Extends %Persistent
{

/// Players, contains their grids and status
Property Players As array Of btships.model.Player;

ForeignKey PlayerForeignKey(Players) References btships.model.Player(PlayerIndex) [ OnDelete = cascade ];

Index PlayerIndex On Players;

/// Game Grid X Axis Size, if undefined the default will be used
Property GameSizeX As %Integer;

/// Game Grid Y Axis Size, if undefined the default will be used
Property GameSizeY As %Integer;

/// Game Fleet Definition defines the playing ship types in the game, leave undefined for default
Property CustomFleetDefinition As array Of btships.model.Ship;

/// Represents the state of play.
/// <p>Available states:</p>
/// <table>
/// <tr>
///     <th>Integer Value</th>
///     <th>Represented State</th>
/// </tr>
/// <tr><td>0</td> <td>New Game</td></tr>
/// <tr><td>1</td> <td>Preparation Phase</td></tr>
/// <tr><td>2</td> <td>Attack Phase</td></tr>
/// <tr><td>3</td> <td>Game Over</td></tr>
/// </table>
Property GameStatus As %Integer;

/// Initializes the game and the players
Method Initialize() As %Status
{
    Try
    {
        Set ..GameStatus = 0

        Set player1 = ##class(btships.model.Player).%New()
        Set player2 = ##class(btships.model.Player).%New()

        Do player1.Initialize(1, ..GameSizeX, ..GameSizeY, ..CustomFleetDefinition)
        Do player2.Initialize(0, ..GameSizeX, ..GameSizeY, ..CustomFleetDefinition)

        Do ..Players.Insert(player1)
        Do ..Players.Insert(player2)

        // player1.%Save(1)
        // player2.%Save(1)
        
        Return $$$OK
    }
    Catch exception
    {
        Do exception.Log()
        Return $$$ERROR(5001)
    }
}

/// Player Issues the command to open fire! Id is the player issuing the attack.
/// Returns the status report of the shot
Method OpenFire(playerId As %Integer, x As %Integer, y As %Integer) As %Integer
{
    Set hitReport = 0 //..SendPlayerOpenFire(x, y, playerId)

    // Broadcast the hit report, 
    // 0 Not The Player's Turn
    // 1 Miss
    // 2 Ship
    // 3 Hit
    // 4 Destroyed
    If ( hitReport > 0 )
    {
        Do ..Report("A shot was fired at x: " + x + ", and y:" + y + " coordinates")
        // Shot was missed
        If ( hitReport = 1 )
        {
            Do ..Report("The crew report the shot missed.")
        }
        // Shot was a hit, the ship survives
        If ( hitReport = 3 )
        {
            Do ..Report("The crew report the shot hit a target!")
        }
        // Shot was a hit and the final blow to the ship
        If ( hitReport = 4 )
        {
            Do Report("The crew report explosions in the scope! the target is destroyed!")
            Do CheckPlayerFleetCount(playerId)
        }
        #; If ( ..GameStatus = 2 )
        #; {
        #;     Do NextPlayerTurn(playerId)
        #; }
    }
    Return hitReport
}

/// TODO: Not completed
Method CheckPlayerFleetCount(playerId As %Integer) As %Status
{
    Set key = ""
    Do 
    {
        Set player = ..Players.GetNext(key)
        If ( player '= "" && player.IsFirstPlayer && player.FleetSize = 0)
        {
            Do Report("Player 2 is defeated! Player 1 wins!")
            Set ..GameStatus = 3
        }
        Elseif ( player '= "" && 'player.IsFirstPlayer && player.FleetSize = 0)
        {
            Do Report("Player 1 is defeated! Player 2 wins!")
            Set ..GameStatus = 3
        }
    } While ( key '= "" )

    Return $$$OK
}

// Method SendPlayerOpenFire(x As %Integer, y As %Integer, playerId As %Integer) As %Integer

// {

//     If ( playerId = 1 )

//     {

//         Set hitReport = ..Player1.OpenFire(x, y)

//     }

//     If ( playerId = 2 )

//     {

//         Set hitReport = ..Player2.OpenFire(x, y)

//     }

//     Return hitReport

// }

/// Reports are used to announce to all players the state of play
Method Report(reportMessage As %String) As %Status
{
    Write !,reportMessage
    Return $$$OK
}

// /// Swap the turn of play to the other player

// Method NextPlayerTurn(playerId As %Integer) As %Status

// {

//     If ( playerId = 1 )

//     {

//         Set ..Player1.IsCurrentTurn = 0

//         Set ..Player2.IsCurrentTurn = 1

//     }

//     If ( playerId = 2 )

//     {

//         Set ..Player1.IsCurrentTurn = 1

//         Set ..Player2.IsCurrentTurn = 0

//     }

//     Return $$$OK

// }

/// Begin the planning phase of the game, where players ships are placed
Method BeginPlanningPhase() As %Status
{
    Set ..GameStatus = 1
    Return $$$OK
}

/// Begin the attack phase of the game, where players fire at each other
Method BeginAttackPhase() As %Status
{
    Set ..GameStatus = 2
    Return $$$OK
}

/// Begin the end of the game, where the victor is declared
Method BeginGameOverPhase() As %Status
{
    Set ..GameStatus = 3
    Return $$$OK
}

}
