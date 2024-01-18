Class btships.production.fire.Operation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

/// baojdgashgeiauewbg
Method OpenFire(pRequest As btships.production.fire.Request, Output pResponse As btships.production.fire.Response) As %Status
{
    Try
    {
        Set pResponse = ##class(btships.production.fire.Response).%New()

        Set request = {}.%FromJSON(pRequest.JSON)
        Set sql = "SELECT enemyGrid.%Id As Id, enemyGrid.SizeX, enemyGrid.SizeY FROM btships.model.Grid As enemyGrid JOIN btships.model.Player As player ON enemyGrid.Id = player.EnemyGrid WHERE player.%Id = ?"
        Set statement = ##class(%SQL.Statement).%New(), statement.%ObjectSelectMode = 1
        Set status = statement.%Prepare(sql)
        If ($$$ISOK(status))
        {
            Set resultSet = statement.%Execute(request.playerId)
            If (resultSet.%SQLCODE = 0)
            {
                While (resultSet.%Next() '= 0)
                {
                    $$$TRACE("Grid is "_resultSet.%GetData(1))
                    Set pResponse.Report = "Shots fired!"
                }
            }
        }
        Else
        { 
            Return $$$ERROR(5001, "Error retrieving the grid with PlayerId = " _ request.playerId)
        }
    }
    Catch exception
    {
        Do exception.Log()
        Return $$$ERROR(5001)
    }
    Return $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="btships.production.fire.Request">
        <Method>OpenFire</Method>
    </MapItem>
</MapItems>
}

}
