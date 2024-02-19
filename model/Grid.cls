/// Represents one Grid of two in a game, contains all the cells of a game during the loop of play
Class btships.model.Grid Extends %Persistent
{

/// The default X size of the grid, if not specified otherwise
Parameter DEFAULTX = 10;

/// The default Y size of the grid, if not specified otherwise
Parameter DEFAULTY = 10;

/// The initial size of the grid's X coordinates
Property SizeX As %Integer;

/// The initial size of the grid's Y coordinates
Property SizeY As %Integer;

Property GridCells As btships.model.Cell;

ForeignKey GridCellForeignKey(GridCells) References btships.model.Cell() [ OnDelete = cascade ];

Index GridCells On GridCells;

Property Player As btships.model.Player;

ForeignKey PlayerForeignKey(Player) References btships.model.Player();

Index Player On Player;

/// This method is to provide the new cell the data needed to instantiate correctly
Method EstablishCell(column As %Integer, row As %Integer, isHomeGrid As %Boolean) As btships.model.Cell
{
    write "cell"
    Try
    {
        Set newCell = ##class(btships.model.Cell).%New()
        If ( isHomeGrid = 1 )
        {
            Do newCell.Initialize(column, row, 5)
        }
        If ( isHomeGrid = 0 )
        {
            Do newCell.Initialize(column, row, 0)
        }

        Return newCell
    }
    Catch exceptionCell
    {
        Do exceptionCell.Log()
        Set newCell = ##class(btships.model.Cell).%New()
        Return newCell
    }
}

/// This method builds the grid
Method BuildGrid(isHomeGrid As %Boolean) As %Status
{
    Set ..GridCells = ##class(%ArrayOfDataTypes).%New()

    For row = 1:1:..SizeY
    {
        For column = 1:1:..SizeX
        {
            Set key = column_":"_row
            Set newCell = ..EstablishCell(column, row, isHomeGrid)

            If ( newCell = "" )
            {
                Return $$$ERROR(5001)
            }

            Do ..GridCells.SetAt(newCell, key)
            //Do newCell.%Save()
        }
    }
    Return $$$OK
}

/// Initialize the input parameters or use default values, set isHomeGrid to true if this is the player's own grid
Method Initialize(initialX As %Integer, initialY As %Integer, isHomeGrid As %Boolean) As %Status
{
    If ( initialX = "" )
    {
        If ( ..SizeX = "" )
        {
            Set ..SizeX = ..#DEFAULTX
        }
        Set ..SizeX = initialX
    }
    If ( initialY = "" )
    {
        If ( ..SizeY = "" )
        {
            Set ..SizeY = ..#DEFAULTY
        }
        Set ..SizeY = initialY
    }

    Try
    {
        Do ..BuildGrid(isHomeGrid)
    }
    Catch exceptionGrid
    {
        Do exceptionGrid.Log()
        Return $$$ERROR(5001)
    }
}

/// Executes the action of a shot being fired
Method OpenFire(x As %Integer, y As %Integer) As %Integer
{
    Set targetCell = ..GridCells.GetAt(x, y)
    Set hitReport = targetCell.ReceiveFire()

    Return hitReport
}

/// Broadcast the hit report message, which is the resulting status of the hit
Method Report(reportMessage As %String) As %Status
{
    Write !,reportMessage
    Return $$$OK
}

Storage Default
{
<Data name="GridDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SizeX</Value>
</Value>
<Value name="3">
<Value>SizeY</Value>
</Value>
<Value name="4">
<Value>GridCells</Value>
</Value>
<Value name="5">
<Value>Player</Value>
</Value>
</Data>
<DataLocation>^btships.model.GridD</DataLocation>
<DefaultData>GridDefaultData</DefaultData>
<IdLocation>^btships.model.GridD</IdLocation>
<IndexLocation>^btships.model.GridI</IndexLocation>
<StreamLocation>^btships.model.GridS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
