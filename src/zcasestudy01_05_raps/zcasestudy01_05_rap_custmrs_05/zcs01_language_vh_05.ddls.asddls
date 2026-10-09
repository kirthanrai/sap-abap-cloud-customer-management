@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Language Value Help'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCS01_LANGUAGE_VH_05
  as select from I_LanguageText
{
  key LanguageCode,

      @Semantics.text: true
      LanguageName
}
where Language = $session.system_language
