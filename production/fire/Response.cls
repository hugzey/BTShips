/// The response message to a request to open fire
Class btships.production.fire.Response Extends (Ens.Response, %JSON.Adaptor)
{

/// The reported effect of the shot
Property Report As %String(MAXLEN = 255);

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>Report</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
