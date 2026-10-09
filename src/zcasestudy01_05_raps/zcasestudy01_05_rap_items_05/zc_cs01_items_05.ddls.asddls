@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZCS01_ITEMS_05'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_CS01_ITEMS_05
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_CS01_ITEMS_05
  association [1..1] to ZR_CS01_ITEMS_05 as _BaseEntity on $projection.CUSTOMERID = _BaseEntity.CUSTOMERID and $projection.ORDERID = _BaseEntity.ORDERID and $projection.ORDERITEM = _BaseEntity.ORDERITEM
{
  key Customerid,
  key Orderid,
  key Orderitem,
  Itemid,
  Itemdescription,
  @Semantics: {
    Quantity.Unitofmeasure: 'Unit'
  }
  Quantity,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'UnitOfMeasure', 
      Entity.Name: 'I_UnitOfMeasureStdVH', 
      Useforvalidation: true
    } ]
  }
  Unit,
  @Semantics: {
    Amount.Currencycode: 'Currency'
  }
  Price,
  ItemTotal,
  @Consumption: {
    Valuehelpdefinition: [ {
      Entity.Element: 'Currency', 
      Entity.Name: 'I_CurrencyStdVH', 
      Useforvalidation: true
    } ]
  }
  Currency,
  Info,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
