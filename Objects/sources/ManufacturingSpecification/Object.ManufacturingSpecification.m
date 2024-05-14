(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[ManufacturingSpecification],{
	Description->"Detailed information concerning the constraints of a given manufacturer on the products they can produce upon demand such as rules on the combinatorial options, product compatibility, and suggested optimizations on how these combinations should be operated.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* --- Organizational Information --- *)
		Authors->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[User],
			Description->"The people who created this manufacturing specification.",
			Category->"Organizational Information"
		},
		Company->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Company][ManufacturingSpecifications,2],
			Description->"The manufacturer that provides this manufacturing specification and supplies the products associated with this specification.",
			Category->"Organizational Information",
			Abstract->True
		},
		DeveloperObject->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category->"Organizational Information",
			Developer->True
		},
		Products->{
			Format->Multiple,
			Class->Link,
			Pattern:>ObjectP[Object[Product]],
			Relation->Object[Product,CapillaryELISACartridge][ManufacturingSpecifications],
			Description->"The products that are associated with this specification.",
			Category->"Organizational Information"
		},

		(* --- Product Information --- *)
		ProductWebsite->{
			Format->Single,
			Class->String,
			Pattern:>URLP,
			Description->"The website address of the products that are associated with this specification.",
			Category->"Product Specifications"
		},
		SpecificationSheet->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description->"A file containing all the detailed specification information provided by the company.",
			Category -> "Product Specifications"
		}
	}
}];
