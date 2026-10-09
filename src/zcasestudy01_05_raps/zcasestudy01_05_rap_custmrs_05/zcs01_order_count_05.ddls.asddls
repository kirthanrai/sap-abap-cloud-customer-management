@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Count per Customer'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCS01_ORDER_COUNT_05
  as select from zcs01_custord_05 as Orders
{
  key Orders.customerid as CustomerId,

      count( * ) as OrderCount
}
group by
  Orders.customerid
