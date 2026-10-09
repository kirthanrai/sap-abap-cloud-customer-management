@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Orders Read View 05'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCS01_CUST_ORDERS_R_05
  with parameters
    p_customerid : zcustomeridt1
  as select from zcs01_custord_05 as Orders

  association [1..1] to ZCS01_CUSTOMERS_R_05 as _Customer on _Customer.Customerid = Orders.customerid

{
  key Orders.customerid            as CustomerId,
  key Orders.orderid               as OrderId,
      Orders.order_date            as OrderDate,

      @Semantics.amount.currencyCode: 'Currency'
      Orders.order_total           as OrderTotal,

      Orders.discount              as Discount,
      Orders.info                  as Info,
      Orders.status                as Status,

      Orders.currency              as Currency,
      Orders.target_currency       as TargetCurrency,
      Orders.change_rate_date      as ChangeRateDate,

      @Semantics.amount.currencyCode: 'TargetCurrency'
      Orders.order_total_converted as OrderTotalConverted,

      Orders.created_by            as CreatedBy,
      Orders.created_at            as CreatedAt,
      Orders.local_last_changed_by as LocalLastChangedBy,
      Orders.local_last_changed_at as LocalLastChangedAt,
      Orders.last_changed_at       as LastChangedAt,

      _Customer
}

where Orders.customerid = $parameters.p_customerid
