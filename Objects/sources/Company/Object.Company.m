(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Company], {
	Description->"A company with which Emerald Cloud Lab interacts.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of a company.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Phone -> {
			Format -> Single,
			Class -> String,
			Pattern :> PhoneNumberP,
			Description -> "The company's primary phone line.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Website -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "The company's website URL.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		OutOfBusiness -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the company is no longer operational.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* Object Certificates *)
		CertificatesCreated -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Report, Certificate][CertificationSource],
			Description -> "Quality documentation that this company is responsible for attesting to the accuracy of the data contained therein.",
			Category -> "Certification Information"
		},

		(* This is NOT a developer field but we do NOT want it to be in UploadCompany either. Updating this field should be limited to developers only and the external users are not supposed to upload to this field. *)
		ManufacturingSpecifications -> {
			Format -> Multiple,
			Class -> {Expression,Link},
			Pattern :> {TypeP[Object[Product]],ObjectP[Object[ManufacturingSpecification]]},
			Relation -> {Null,Object[ManufacturingSpecification][Company]},
			Description -> "Detailed information concerning the constraints of a given manufacturer on the products they can produce upon demand such as rules on the combinatorial options, product compatibility, and suggested optimizations on how these combinations should be operated.",
			Headers -> {"Product Type","Manufacturing Specification"},
			Category -> "Organizational Information"
		},
		(* --- Migration Support --- *)
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
