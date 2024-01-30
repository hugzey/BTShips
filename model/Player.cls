/// Represents the player, playing a game
Class btships.model.Player Extends %Persistent
{

/// The player's place in the game, this determines if they start the first move or not
Property IsFirstPlayer As %Boolean;

/// The player's grids,
/// the first of two containing their ships and grid cells,
/// the second containing the opposing player's ships and grid cells
Property Grids As array Of btships.model.Grid;

ForeignKey GridForeignKey(Grids) References btships.model.Grid(GridIndex) [ OnDelete = cascade ];

Index GridIndex On Grids;

/// Is it this player's turn
Property IsCurrentTurn As %Boolean;

/// The player's fleet, which contains all their ships
Property Fleet As array Of btships.model.Fleet;

ForeignKey FleetForeignKey(Fleet) References btships.model.Fleet(FleetIndex) [ OnDelete = cascade ];

Index FleetIndex On Fleet;

/// Current Ship selected for placement
Property SelectedShip As btships.model.Ship;

Property Game As btships.model.Game;

ForeignKey GameForeignKey(Game) References btships.model.Game(GameIndex);

Index GameIndex On Game;

// Relationship Game As btships.model.Game [ Cardinality = parent, Inverse = Players ];

/// Initializes the player
/// If Player Id = 1 then that player will start
Method Initialize(isFirstPlayer As %Integer, gridX As %Integer, gridY As %Integer, fleetTemplate As %ArrayOfObjects) As %Status
{
    Try
    {
        Set homeGrid = ##class(btships.model.Grid).%New()
        Do homeGrid.Initialize(gridX, gridY, 1)
        Do ..Grids.Insert(homeGrid)
        //Do homeGrid.%Save()
    }
    Catch exception
    {
        Do exception.Log()
        Return $$$ERROR(5001)
    }

    Try
    {
        Set enemyGrid = ##class(btships.model.Grid).%New()
        Do enemyGrid.Initialize(gridX, gridY, 0)
        Do ..Grids.Insert(enemyGrid)
        //Do enemyGrid.%Save()
    }
    Catch exception
    {
        Do exception.Log()
        Return $$$ERROR(5001)
    }

    Try
    {
        Set ..Fleet = ##class(btships.model.Fleet).%New()
        If ( fleetTemplate '= "")
        {
            Set ..Fleet.FleetTemplate = fleetTemplate
        }
        Do ..Fleet.Initialize()
        //Do fleet.%Save()

    }
    Catch exception
    {
        Do exception.Log()
        Return $$$ERROR(5001)
    }

    // If player one
    If ( isFirstPlayer )
    {
        Set ..IsFirstPlayer = 1
        Set ..IsCurrentTurn = 1
    }
    Else
    {
        Set ..IsFirstPlayer = 0
        Set ..IsCurrentTurn = 0
    }

    Return $$$OK
}

/// Issue the command to fire, this executes the OpenFire method in the grid for this player's enemy grid.
/// If it is the player's turn:
/// Returns the hit report status of the shot fired.
/// Otherwise return 0
Method OpenFire(x As %Integer, y As %Integer) As %Integer
{
    If ( ..IsItMyTurn() )
    {
        Set hitReport = 0 //..EnemyGrid.OpenFire(x, y)

        Return hitReport
    }
    Else
    {
        Return 0
    }
}

/// Find out if it's this player's turn yet.
/// Returns boolean true if it is.
Method IsItMyTurn() As %Boolean
{
    Return ..IsCurrentTurn
}

}
