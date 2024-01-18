Class btships.production.grid.BusinessService Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
        Try
        {
            set getGridRequest = ##class(btships.production.grid.Request).%New()
            set getGridRequest.pid = pInput

            Do ..SendRequestSync("btships.production.grid.Operation", getGridRequest, .pResponse)
            
            if $ISOBJECT(pResponse)
            {                    
                set pOutput = pResponse
            }
            else
            {
                $$$TRACE("Grid not found")
                set pOutput.Name = "Anonymous"
            }            
        } 
        Catch (ex)
        {
            Do ex.Log()
        }
        Return $$$OK
}

}
