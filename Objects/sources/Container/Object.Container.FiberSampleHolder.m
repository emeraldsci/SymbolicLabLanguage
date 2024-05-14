(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container,FiberSampleHolder],{
	Description->"A fiber sample holder used to hold the fiber samples and mount into the single fiber tensiometer instrument.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		StickerLog->{
			Format->Multiple,
			Class->{Expression,Link},
			Pattern:>{_?DateObjectQ,_Link},
			Relation->{Null,Object[Protocol]|Object[Qualification]|Object[Maintenance]},
			Headers->{"Date","Use"},
			Description->"The dates the sticker has previously been changed in protocols.",
			Category->"General"
		},
		UsageLog->{
			Format->Multiple,
			Class->{Expression,Link,Link},
			Pattern:>{_?DateObjectQ,_Link,_Link},
			Relation->{Null,Object[Protocol]|Object[Qualification]|Object[Maintenance],Object[Sample]},
			Headers->{"Date","Use","Sample"},
			Description->"The dates the probe has previously been used to take measurements of samples.",
			Category->"General"
		}
	}
}];

