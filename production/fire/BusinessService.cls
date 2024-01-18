Class btships.production.fire.BusinessService Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
        Try 
        {
            #Dim openFireRequest As btships.production.fire.Request
            set openFireRequest = ##class(btships.production.fire.Request).%New()
            set openFireRequest.JSON = pInput
            Set tSC = ..SendRequestSync("btships.production.fire.OpenFire", openFireRequest, .pResponse)
            if $ISOBJECT(pResponse)
            {
                set pOutput = pResponse
            }        
        } 
        Catch (ex)
        {
            set error = ex.DisplayString()            
            set pOutput.errormessage = error
        }
        Quit $$$OK
}

}
