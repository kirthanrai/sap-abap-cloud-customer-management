@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Maximum Sales per Customer'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCS01_MAX_SALES_CUST_05
  as select from zcs01_custord_05 as Orders
{
  key Orders.customerid as CustomerId,

      @Semantics.amount.currencyCode: 'Currency'
      max( Orders.order_total ) as MaxSales,

      Orders.currency as Currency
}
group by
  Orders.customerid,
  Orders.currency
