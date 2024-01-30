/// Represents the data object of a single cell in a game grid
Class btships.model.Cell Extends %Persistent
{

/// The X coordinate of the game grid, that this cell represents, X is the horizontal axis
Property X As %Integer;

/// The Y coordinate of the game grid, that this cell represents, Y is the vertical axis
Property Y As %Integer;

/// Represents the state of the cell, this can be the following:
/// 0 - Unknown
/// 1 - Miss
/// 2 - Ship
/// 3 - Hit
/// 4 - Destroyed
/// 5 - Water
/// 6 - Proposed Ship Position
Property Status As %Integer [ InitialExpression = 0 ];

/// If this cell has part of a ship within it's bounds, reference the parent ship
Property OccupyingShip As btships.model.Ship;

Property Grid As btships.model.Grid;

ForeignKey GridForeignKey(Grid) References btships.model.Grid(GridIndex);

Index GridIndex On Grid;

/// Initializes a new cell with the provided arguments for initialization
Method Initialize(xInput As %Integer, yInput As %Integer, status As %Integer) As %Status
{
        set ..X = xInput
        set ..Y = yInput
        set ..Status = status

        return $$$OK
}

/// Executes actions on the hit and reports the status
Method ReceiveFire() As %Integer
{
        // If there's a ship on this space
        if ( ..OccupyingShip '= "" )
        {
            // Apply the hit and receive the resulting ship's status
            Set shipStatus = ..OccupyingShip.Hit()

            // If the ship is now destroyed
            if ( shipStatus = 2 )
            {
                Set ..Status = 4
                Return ..Status
            }

            // If the ship still survives
            if ( shipStatus = 1 )
            {
                Set ..Status = 3
                Return ..Status
            }
        }

        // If there was not a ship on this space
        if ( ..OccupyingShip = "")
        {
            Set ..Status = 1
        }

        Return ..Status
}

Storage Default
{
<Data name="CellDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>X</Value>
</Value>
<Value name="3">
<Value>Y</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>OccupyingShip</Value>
</Value>
<Value name="6">
<Value>Grid</Value>
</Value>
</Data>
<DataLocation>^btships.model.CellD</DataLocation>
<DefaultData>CellDefaultData</DefaultData>
<IdLocation>^btships.model.CellD</IdLocation>
<IndexLocation>^btships.model.CellI</IndexLocation>
<StreamLocation>^btships.model.CellS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
