@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View for customers table'
@Metadata.ignorePropagatedAnnotations: true


define view entity ZCS01_CUSTOMERS_R_05 as select from zcs01_custmrs_05
{
    key customerid as Customerid,
    salutation as Salutation,
    last_name as LastName,
    first_name as FirstName,
    company as Company,
    street as Street,
    city as City,
    country as Country,
    postcode as Postcode,
    acc_lock as AccLock,
    last_date as LastDate,
    
    @Semantics.amount.currencyCode: 'Currency'
    sales_volume as SalesVolume,
    
    @Semantics.amount.currencyCode: 'Currency'
    sales_volume_target as SalesVolumeTarget,
    
    change_rate_date as ChangeRateDate,
    fax as Fax,
    phone as Phone,
    email as Email,
    url as Url,
    currency as Currency,
    currency_target as CurrencyTarget,
    language as Language,
    weblogin as Weblogin,
    webpw as Webpw,
    memo as Memo,
    created_by as CreatedBy,
    created_at as CreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt
}
