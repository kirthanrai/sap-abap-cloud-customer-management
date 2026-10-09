@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCS01_CUSTORD_05000'
}
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZC_CS01_CUSTORD_05000
  as projection on ZR_CS01_CUSTORD_PC_05
  
  association [1..1] to ZR_CS01_CUSTORD_PC_05 as _BaseEntity 
    on $projection.Customerid = _BaseEntity.Customerid 
    and $projection.Orderid = _BaseEntity.Orderid
{
  key Customerid,
  key Orderid,
  OrderDate,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  OrderTotal,
  Discount,
  Info,
  Status,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  Currency,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  TargetCurrency,
  ChangeRateDate,
  @Semantics: {
    amount.currencyCode: 'TargetCurrency'
  }
  OrderTotalConverted,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  
  _Customer : redirected to parent ZC_CS01_CUSTMRS_05000,
  
  _BaseEntity
}
