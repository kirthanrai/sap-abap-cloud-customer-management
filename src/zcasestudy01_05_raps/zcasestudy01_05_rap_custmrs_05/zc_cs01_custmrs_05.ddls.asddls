@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZCS01_CUSTMRS_05'
}
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_CS01_CUSTMRS_05
  provider contract transactional_query
  as projection on ZR_CS01_CUSTMRS_05
  association [1..1] to ZR_CS01_CUSTMRS_05 as _BaseEntity on $projection.Customerid = _BaseEntity.Customerid
{
  key     Customerid,
          Salutation,
          LastName,
          FirstName,
          Company,
          Street,
          City,
          @Consumption.valueHelpDefinition: [
          {
            entity: {
              name: 'ZCS01_COUNTRY_VH_05',
              element: 'Country'
            }
          }
          ]
          Country,
          Postcode,
          AccLock,
          LastDate,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CS1_ORDER_COUNT_05'
          @EndUserText.label: 'Number of Orders'
  virtual OrderCount : abap.int4,

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
          @Consumption.valueHelpDefinition: [
          {
          entity: {
          name: 'ZCS01_LANGUAGE_VH_05',
          element: 'LanguageCode'
          }
          }
          ]
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
          _BaseEntity
}
