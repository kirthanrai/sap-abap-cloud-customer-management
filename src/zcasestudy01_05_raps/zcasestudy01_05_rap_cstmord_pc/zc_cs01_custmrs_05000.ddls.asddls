@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCS01_CUSTMRS_05000'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_CS01_CUSTMRS_05000
  provider contract transactional_query
  as projection on ZR_CS01_CUSTMRS_PC_05
  association [1..1] to ZR_CS01_CUSTMRS_PC_05 as _BaseEntity on $projection.Customerid = _BaseEntity.Customerid
{
  key Customerid,
  Salutation,
  LastName,
  FirstName,
  Company,
  Street,
  City,
  Country,
  Postcode,
  AccLock,
  LastDate,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  SalesVolume,
  @Semantics: {
    amount.currencyCode: 'CurrencyTarget'
  }
  SalesVolumeTarget,
  ChangeRateDate,
  Fax,
  Phone,
  Email,
  Url,
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
  CurrencyTarget,
  Language,
  Weblogin,
  Webpw,
  Memo,
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
  Zzvip,
  
  _Orders : redirected to composition child ZC_CS01_CUSTORD_05000,
  
  _BaseEntity
}
