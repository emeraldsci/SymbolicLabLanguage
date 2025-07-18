

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Certificate],{
	(* This object holds fields for information shared by third party certificate documents (Certificate of Analysis,
	Certificate of Calibration, etc.). *)
	Description->"Metadata and documentation for third-party certified quality documents verifying properties of an object.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* Objects Certified *)
		ItemCertified->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item][Certificates],
			Description->"The item with the properties and batch number contained in the certificate.",
			Category->"General"
		},
		PartCertified->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part][Certificates],
			Description->"The part with the properties and batch number contained in the certificate.",
			Category->"General"
		},
		InstrumentCertified->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument][Certificates,2],
			Description->"The instrument or instrument module with serial and model numbers listed in the certificate.",
			Category->"General"
		},

		(* Certification Information *)
		CertificationSource->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Company][CertificatesCreated],
			Description->"The agency or company responsible for verifying the accuracy of the data contained in the certificate document.",
			Category->"Certification Information"
		},
		BatchNumber->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The batch or lot number of the sample, part, or item certified by this document.",
			Category->"Certification Information"
		},
		Document->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"File containing an image or digital version of the Certificate document that corresponds to the object's batch number.",
			Category->"Certification Information"
		}
	}
}];