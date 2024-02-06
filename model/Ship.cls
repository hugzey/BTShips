/// Represents a piece on the grid in the game, these can be played, hit and destroyed.
Class btships.model.Ship Extends %Persistent
{

/// Length of the ship, typically they are longer than they are wide.
Property Length As %Integer;

/// Width of the ship
Property Width As %Integer;

/// Total Hit points of the ship, this is what it starts with
Property TotalHitPoints As %Integer;

/// Hit points of the ship is also equal to the total area of the ship
Property HitPoints As %Integer;

/// The current amount of hits taken
Property HitsTaken As %Integer;

/// Status of the ship, can either be 0 Not Placed, 1 OK, 2 Damaged, 3 Destroyed, 4 To be placed
Property Status As %Integer;

/// This states true if the ship is alligned vertically with the Y axis
Property IsVerticallyAlligned As %Boolean;

Property Fleet As btships.model.Fleet;

ForeignKey FleetForeignKey(Fleet) References btships.model.Fleet();

Index Fleet On Fleet;

/// Initializes the ship with it's provided arguments to populate the properties.
Method Initialize(length As %Integer, width As %Integer) As %Status
{
    Set ..Length = length
    Set ..Width = width
    Set ..TotalHitPoints = ..Width * ..Length
    Set ..HitsTaken = 0
    Set ..Status = 4
    set ..HitPoints = ..TotalHitPoints - ..HitsTaken

    Return $$$OK
}

/// Calculates the current hit points and status
Method CheckStatus() As %Status
{
    set ..HitPoints = ..TotalHitPoints - ..HitsTaken
    If ( ..Status = 4 )
    {
        Return $$$OK
    }
    Elseif ( ..HitPoints = 0 )
    {
        Set ..Status = 3
        Return $$$OK
    }
    Elseif ( ..HitPoints < ..TotalHitPoints )
    {
        Set ..Status = 2
        Return $$$OK
    }
    Elseif ( ..HitPoints = ..TotalHitPoints )
    {
        Set ..Status = 1
        Return $$$OK
    }
    Else
    {
        Return $$$ERROR(5001, "Unexpected Path")
    }
}

/// Registers a hit against this ship, returns the status
Method Hit() As %Integer
{
    Set ..HitsTaken = ..HitsTaken + 1
    Do CheckStatus()

    Return ..Status
}

Storage Default
{
<Data name="ShipDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Length</Value>
</Value>
<Value name="3">
<Value>Width</Value>
</Value>
<Value name="4">
<Value>TotalHitPoints</Value>
</Value>
<Value name="5">
<Value>HitPoints</Value>
</Value>
<Value name="6">
<Value>HitsTaken</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>IsVerticallyAlligned</Value>
</Value>
<Value name="9">
<Value>Fleet</Value>
</Value>
</Data>
<DataLocation>^btships.model.ShipD</DataLocation>
<DefaultData>ShipDefaultData</DefaultData>
<IdLocation>^btships.model.ShipD</IdLocation>
<IndexLocation>^btships.model.ShipI</IndexLocation>
<StreamLocation>^btships.model.ShipS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
