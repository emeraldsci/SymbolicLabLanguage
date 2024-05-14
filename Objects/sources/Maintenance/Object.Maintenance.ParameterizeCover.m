(* ::Package:: *)

(* ParameterizeCover *)

DefineObjectType[Object[Maintenance,ParameterizeCover],{
  Description->"A protocol that parameterizes the dimensions, shape, and properties of new covers that are received.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    ParameterizationModels->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
        Model[Item,Cap][Parameterizations],
        Model[Item,Lid][Parameterizations],
        Model[Item, PlateSeal][Parameterizations]
      ],
      Description->"For each member of Covers, the model of the cover that this maintenance is parameterizing. These models are updated during parameterization if an equivalent model is found.",
      Category->"Qualifications & Maintenance",
      IndexMatching->Covers,
      Abstract->True
    },
    TargetParameterizationModels->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
        Model[Item,Cap],
        Model[Item,Lid],
        Model[Item, PlateSeal]
      ],
      Description->"For each member of Covers, the model of the cover that this maintenance is parameterizing.",
      Category->"Qualifications & Maintenance",
      IndexMatching->Covers
    },
    Covers->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Item, Cap],Model[Item,Cap], Object[Item, Lid],Model[Item,Lid], Model[Item, PlateSeal], Object[Item, PlateSeal]],
      Description->"The specific covers that this maintenance is parameterizing.",
      Category->"Qualifications & Maintenance",
      Abstract->True
    },
    Containers->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Container, Vessel], Object[Container, Plate], Object[Container, Cuvette]],
      Description->"The specific containers upon which the cover is located.",
      Category->"Qualifications & Maintenance",
      Abstract->True
    },
    NewModel -> {
      Format ->Multiple,
      Class ->Boolean,
      Pattern:>BooleanP,
      Description -> "For each member of Covers, True indicates that the target cover has been parameterized in this maintenance and False indicates that an equivilant model has been found.",
      Category -> "Qualifications & Maintenance",
      IndexMatching -> Covers
    },
    (*This is going to be uploaded fresh each loop, we dont need to keep it around once we turn it into a model*)
    EquivalentObject -> {
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The IDs of container matching the model of the container being parameterized.",
      Category->"Qualifications & Maintenance",
      Developer ->True
    },
    PossibleMatchingCovers -> {
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Item, Lid],Model[Item, Cap], Model[Item, PlateSeal]],
      Description->"The specific container vessels that this maintenance is parameterizing. It is continuously updated during the Maintenance based on operator feedback.",
      Category->"Qualifications & Maintenance",
      Developer -> True
    },
    PossibleMatchingCoversResult -> {
      Format->Multiple,
      Class->Boolean,
      Pattern:>BooleanP,
      Description->"The operators assessment of each of the displayed PossibleMatchingCovers.",
      Category->"Qualifications & Maintenance",
      Developer ->True
    },
    ScoutWidth->{
      Format->Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 * Millimeter],
      Units -> Millimeter,
      Description->"For each member of Covers, the measured width of the cover.",
      Category -> "General",
      IndexMatching->Covers
    },
    ScoutHeight->{
      Format->Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 * Millimeter],
      Units -> Millimeter,
      Description->"For each member of Covers, the measured height of the cover.",
      Category -> "General",
      IndexMatching->Covers
    },
    ImagedItems ->{
      Format -> Multiple,
      Class -> Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Item, Cap], Object[Item, Lid], Object[Container], Object[Item, PlateSeal]],
      Description -> "The collection of containers and covers that will be imaged in order to populate the ImageFile field of the object's Model.",
      Category -> "General"
    },
    ParameterizationResources->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Item, Cap],Model[Item,Cap], Object[Item, Lid],Model[Item,Lid], Model[Item, PlateSeal],Object[Container]],
      Description->"Container and cap resources that need to be gathered for parameterization.",
      Category->"General"
    }
  }
}];
