Class btships.production.external.TestExternalRestOperation Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Property Adapter As btships.production.external.TestExternalRestAdapter;

Method OpenFire(pRequest As btships.production.fire.Request, Output pResponse As btships.production.fire.Response) As %Status
{
    try
    {
        Set pResponse = ##class(btships.production.fire.Response).%New()

        Set tPayload = pRequest.JSON
        
        Set tSC = $$$OK
        Set tSC = ..Adapter.Post(.adapterOutput, , tPayload)

        Set idfk = adapterOutput.Data
        Set idfk = idfk.Read(idfk.Size)
        Set dataObj = ##class(%DynamicAbstractObject).%FromJSON(idfk)
        Set pResponse.Report = dataObj.%Get("Report", "No data", "string")
    }
    catch ex
    {
        Set error = ex.AsStatus()
        Set tSC = error
    }
    Return tSC
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
