

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Report, Certificate],{
	(* This model holds fields for depicting where information can be found on a quality document from a third party certificate of analysis for certified analytical calibrants or standards.*)
	Description->"Contains depictions example documents and where data fields can be found within them for third-party certified quality documents verifying properties of an object.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		ModelsSupported -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate][ReceivingBatchCertificateExample],
				Model[Sample][ReceivingBatchCertificateExample]
			],
			Description -> "Object models that use this type of certificate.",
			Category -> "General"
		},
		(* Certification Information *)
		CertificationSource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company][CertificateModels],
			Description -> "The agency or company responsible for verifying the accuracy of the data contained in the certificate document.",
			Category -> "Certification Information"
		},
		BatchNumber -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image file depicting the location of the batch or lot number on this certificate.",
			Category -> "Certification Information"
		},
		Document -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "File containing an image or digital version of an example Certificate document for this model.",
			Category -> "Certification Information"
		}
	}
}];