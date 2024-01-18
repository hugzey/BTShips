Class btships.production.external.TestExternalRestAdapter Extends EnsLib.HTTP.OutboundAdapter
{

Method Post(Output httpResponse As %Net.HttpResponse, formVarNames As %String, data...) As %Status
{
        Set request = ..GetRequest()
        Set status = ..SendFormDataArray(.httpResponse, "POST", request, .formVarNames, .data)

        Return status
}

ClassMethod GetRequest() As %Net.HttpRequest
{
        Set request = ##class(%Net.HttpRequest).%New()
        Set request.ContentType = "application/json"

        Return request
}

}
