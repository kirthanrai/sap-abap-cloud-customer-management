@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Country value help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCS01_COUNTRY_VH_05
  as select from I_CountryText
{
      key Country,

      @Semantics.text: true
      CountryName
}
where Language = $session.system_language
