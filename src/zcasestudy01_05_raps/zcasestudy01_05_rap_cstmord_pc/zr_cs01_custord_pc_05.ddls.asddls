@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCS01_CUSTORD_05000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_CS01_CUSTORD_PC_05
  as select from zcs01_custord_05 as Orders_PC
  
  association to parent ZR_CS01_CUSTMRS_PC_05 as _Customer
  on $projection.Customerid = _Customer.Customerid
{
  key customerid as Customerid,
  key orderid as Orderid,
  order_date as OrderDate,
  @Semantics.amount.currencyCode: 'Currency'
  order_total as OrderTotal,
  discount as Discount,
  info as Info,
  status as Status,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  target_currency as TargetCurrency,
  change_rate_date as ChangeRateDate,
  @Semantics.amount.currencyCode: 'TargetCurrency'
  order_total_converted as OrderTotalConverted,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  _Customer
}
