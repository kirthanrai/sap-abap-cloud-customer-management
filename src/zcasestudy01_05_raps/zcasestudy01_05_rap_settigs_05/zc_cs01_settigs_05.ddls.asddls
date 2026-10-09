@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZCS01_SETTIGS_05'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_CS01_SETTIGS_05
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_CS01_SETTIGS_05
  association [1..1] to ZR_CS01_SETTIGS_05 as _BaseEntity on $projection.KEYCODE = _BaseEntity.KEYCODE
{
  key KeyCode,
  Value,
  Active,
  @Semantics: {
    User.Createdby: true
  }
  LocalCreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  LocalCreatedAt,
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
