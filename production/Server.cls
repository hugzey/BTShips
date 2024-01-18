Class btships.production.Server Extends %CSP.REST
{

Parameter HandleCorsRequest = 0;

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/GetGrid/:pid" Method="GET" Call="GetGrid" />
    <Route Url="/OpenFire" Method="POST" Call="OpenFire" />
    <Route Url="/TestExternalRESTService" Method="POST" Call="TestExternalRestService" />
</Routes>
}

ClassMethod OnHandleCorsRequest(url As %String) As %Status
{
        set url = %request.GetCgiEnv("HTTP_REFERER")
        set origin = $p(url,"/",1,3) // origin = "http(s)://origin.com:port"
        // here you can check specific origins
        // otherwise, it will allow all origins (useful while developing only)
        do %response.SetHeader("Access-Control-Allow-Credentials","true")
        do %response.SetHeader("Access-Control-Allow-Methods","GET,POST,PUT,DELETE,OPTIONS")
        do %response.SetHeader("Access-Control-Allow-Origin",origin)
        do %response.SetHeader("Access-Control-Allow-Headers","Access-Control-Allow-Origin, Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control")
        
        Return $$$OK
}

// Class method to retrieve the data of a person filtered by PlayerId

ClassMethod GetGrid(pid As %Integer) As %Status
{
        Try {
            Do ##class(%REST.Impl).%SetContentType("application/json")
            if ( '##class(%REST.Impl).%CheckAccepts("application/json") )
            {
                Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
            }
            
            // Creation of get grid service instance
            Do ##class(Ens.Director).CreateBusinessService("btships.production.grid.BusinessService", .instance)

            // Invocation of get grid service with pid parameter
            Do instance.OnProcessInput(pid, .response)
            if ( $ISOBJECT(response) )
            {
                // Sending grid data to client in JSON format
                Do ##class(%REST.Impl).%WriteResponse(response.%JSONExport())
            }
            
        }
        Catch (ex)
        {
            Do ##class(%REST.Impl).%SetStatusCode("400")
            Do ##class(%REST.Impl).%WriteResponse(ex.DisplayString())
            Return {"errormessage": "Client error"}
        }
        Return $$$OK
}

// Class method to receive person data to persist in our database

ClassMethod OpenFire() As %Status
{
    Try
    {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If ( '##class(%REST.Impl).%CheckAccepts("application/json") )
        {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
        }

        Set bodyJson = %request.Content.Read()
        
        Do ##class(Ens.Director).CreateBusinessService("btships.production.fire.BusinessService", .instance)

        Do instance.OnProcessInput(bodyJson, .response)
        
        if $ISOBJECT(response)
        {
            Do ##class(%REST.Impl).%WriteResponse(response.%JSONExport())
        }
        
    }
    Catch (ex)
    {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        Do ##class(%REST.Impl).%WriteResponse(ex.DisplayString())
        Return {"errormessage": "Client error"}
    }

    Return $$$OK
}

ClassMethod TestExternalRestService() As %Status
{
    Try
    {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If ( '##class(%REST.Impl).%CheckAccepts("application/json") )
        {
            Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts))
        }

        Set bodyJson = %request.Content.Read()
        
        Do ##class(Ens.Director).CreateBusinessService("btships.production.external.TestExternalRestService", .instance)

        Do instance.OnProcessInput(bodyJson, .response)
        
        if $ISOBJECT(response)
        {
            Do response.%JSONExport()
        }
        
    }
    Catch (ex)
    {
        Do ##class(%REST.Impl).%SetStatusCode("400")
        Do ##class(%REST.Impl).%WriteResponse(ex.DisplayString())
        return {"errormessage": "Client error"}
    }

    Return $$$OK
}

}
