@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCS01_ITEMS_05'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_CS01_ITEMS_05
  as select from ZCS01_ITEMS_05 as orderitems_05
{
  key customerid as Customerid,
  key orderid as Orderid,
  key orderitem as Orderitem,
  itemid as Itemid,
  itemdescription as Itemdescription,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  quantity as Quantity,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  unit as Unit,
  @Semantics.amount.currencyCode: 'Currency'
  price as Price,
  item_total as ItemTotal,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  info as Info,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
