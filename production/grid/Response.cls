Class btships.production.grid.Response Extends (Ens.Response, %JSON.Adaptor)
{

Property GridId As %Integer;

Property GridX As %Integer;

Property GridY As %Integer;

Storage Default
{
<Data name="ResponseDefaultData">
<Subscript>"Response"</Subscript>
<Value name="1">
<Value>GridId</Value>
</Value>
<Value name="2">
<Value>GridX</Value>
</Value>
<Value name="3">
<Value>GridY</Value>
</Value>
</Data>
<DefaultData>ResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
