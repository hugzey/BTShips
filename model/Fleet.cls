/// Fleet is a collection of ships
Class btships.model.Fleet Extends %Persistent
{

/// Fleet Size is the current amount of ships in the fleet that are not destroyed.
Property FleetSize As %Integer;

/// Starting fleet Size is how many ships entered into battle
Property StartingFleetSize As %Integer;

/// The collection of all ships in the fleet
Property Ships As btships.model.Ship;

ForeignKey ShipsForeignKey(Ships) References btships.model.Ship() [ OnDelete = cascade ];

Index Ships On Ships;

Property Player As btships.model.Player;

ForeignKey PlayerForeignKey(Player) References btships.model.Player();

Index Player On Player;

/// The template to use for initializing the game, this can be set to change the ships that are used in the game
Property FleetTemplate As array Of btships.model.Ship;

/// Initializes the collection of ships for this fleet.
/// If the FleetTemplate has not already been set, will use the default ships
/// Default Fleet Template contains the following ships:
/// <ol>
///     <li>Patrol: 2,1</li>
///     <li>Attack Boat: 3,1</li>
///     <li>Submarine: 3,1</li>
///     <li>Destroyer: 4,1</li>
///     <li>Carrier: 5,1</li>
/// </ol>
Method Initialize() As %Status
{
        Try
        {
            If ( '$ISOBJECT(..FleetTemplate) && ..FleetTemplate.Count() = 0 )
            {
                Set ..FleetTemplate = ##class(%ArrayOfObjects).%New()

                Set patrolBoat = ##class(btships.model.Ship).%New()
                Do patrolBoat.Initialize(2, 1)
                Do ..FleetTemplate.SetAt(patrolBoat, 1)
                
                Set attackBoat = ##class(btships.model.Ship).%New()
                Do attackBoat.Initialize(3, 1)
                Do ..FleetTemplate.SetAt(attackBoat, 2)

                Set submarine = ##class(btships.model.Ship).%New()
                Do submarine.Initialize(3, 1)
                Do ..FleetTemplate.SetAt(submarine, 3)

                Set destroyer = ##class(btships.model.Ship).%New()
                Do destroyer.Initialize(4, 1)
                Do ..FleetTemplate.SetAt(destroyer, 4)

                Set carrier = ##class(btships.model.Ship).%New()
                Do carrier.Initialize(5, 1)
                Do ..FleetTemplate.SetAt(carrier, 5)
            }
        
            Set key = ""
            Do 
            {
                Set ship = ..FleetTemplate.GetNext(key)
                If ( ship '= "" )
                {
                    Do ..Ships.Insert(ship)
                }
            } While ( key '= "" )


            Set ..StartingFleetSize = ..Ships.Count()
            Set ..FleetSize = ..StartingFleetSize

            Return $$$OK
        }
        Catch exception
        {
            Do exception.Log()
            Return $$$ERROR(ObjectScriptError, "Exception occurred during fleet initialization")
        }
}

Storage Default
{
<Data name="FleetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FleetSize</Value>
</Value>
<Value name="3">
<Value>StartingFleetSize</Value>
</Value>
<Value name="4">
<Value>Ships</Value>
</Value>
<Value name="5">
<Value>Player</Value>
</Value>
</Data>
<Data name="FleetTemplate">
<Attribute>FleetTemplate</Attribute>
<Structure>subnode</Structure>
<Subscript>"FleetTemplate"</Subscript>
</Data>
<DataLocation>^btships.model.FleetD</DataLocation>
<DefaultData>FleetDefaultData</DefaultData>
<IdLocation>^btships.model.FleetD</IdLocation>
<IndexLocation>^btships.model.FleetI</IndexLocation>
<StreamLocation>^btships.model.FleetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
