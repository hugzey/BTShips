Class btships.production.grid.Operation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method Get(pRequest As btships.production.grid.Request, Output pResponse As btships.production.grid.Response) As %Status
{
        try
        {
            set pResponse = ##class(btships.production.grid.Response).%New()

            set sql = "SELECT homeGrid.%Id As Id, homeGrid.SizeX, homeGrid.SizeY FROM btships.model.Grid As homeGrid JOIN btships.model.Player As player ON homeGrid.Id = player.HomeGrid WHERE player.%Id = ?"
            set statement = ##class(%SQL.Statement).%New(), statement.%ObjectSelectMode = 1
            set status = statement.%Prepare(sql)
            if ($$$ISOK(status)) {
                set resultSet = statement.%Execute(pRequest.pid)
                if (resultSet.%SQLCODE = 0)
                {
                    while (resultSet.%Next() '= 0)
                    {
                        $$$TRACE("Grid is "_resultSet.%GetData(1))
                        set grid = ##class(btships.model.Grid).%OpenId(resultSet.%GetData(1))
                        set pResponse.GridId = grid.%Id()
                        set pResponse.GridX = grid.SizeX
                        set pResponse.GridY = grid.SizeY
                    }
                }
            }
            else
            { 
                set tSC = "Error retrieving the grid with PlayerId = "_pRequest.pid
            }
            set tSC = $$$OK
        }
        catch exception
        {
            Set tSC=$$$SystemError
        }
        Return tSC
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="btships.production.grid.Request">
        <Method>Get</Method>
    </MapItem>
</MapItems>
}

}
