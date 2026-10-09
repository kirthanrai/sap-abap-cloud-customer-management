@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity ZCS01_STATUS_R_05
  as select from zcs01_status_05
{
      @UI.lineItem: [ { position: 10 } ]
      @Search.defaultSearchElement: true
  key status      as Status,

      @UI.lineItem: [ { position: 20 } ]
      @Semantics.text: true
      @Search.defaultSearchElement: true
      status_text as StatusText
}
where spras = $session.system_language
