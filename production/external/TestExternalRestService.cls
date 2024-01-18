Class btships.production.external.TestExternalRestService Extends Ens.BusinessService
{

Method OnProcessInput(input As %RegisteredObject, Output output As %RegisteredObject) As %Status
{
    Try
    {
        Set openFireRequest = ##class(btships.production.fire.Request).%New()
        Set openFireRequest.JSON = input
        Do ..SendRequestSync("btships.production.external.TestExternalRestOperation", openFireRequest, .pResponse)
        If $IsObject(pResponse)
        {
            Set text = pResponse
            Set output = text
        }
    }
    Catch exception
    {
        Do exception.Log()
        Return $$$ERROR(5001)
    }

    Return $$$OK
}

}
