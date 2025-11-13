(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelReportQTests*)


validModelReportQTests[packet:PacketP[Model[Report]]]:={

	NotNullFieldTest[packet,{DateCreated,Authors}],

	Test["If DateCreated is informed, it is in the past:",
		Lookup[packet, DateCreated],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	]
};

validModelReportCertificateQTests[packet:PacketP[Model[Report, Certificate]]]:={

	NotNullFieldTest[packet,{ModelsSupported, CertificationSource, BatchNumber, Document}]

};

validModelReportCertificateAnalysisQTests[packet:PacketP[Model[Report, Certificate, Analysis]]]:={

	(** All receiving batch information fields required by the supported sample/container's model are populated **)
	(* Object[Sample] *)
	RequiredTogetherTest[
		SafeEvaluate[{Download[Lookup[packet, ModelsSupported], ReceivingBatchInformation]},
			Download[Lookup[packet, ModelsSupported], ReceivingBatchInformation]
		]
	]
};

registerValidQTestFunction[Model[Report],validModelReportQTests];
registerValidQTestFunction[Model[Report, Certificate],validModelReportCertificateQTests];
registerValidQTestFunction[Model[Report, Certificate,Analysis],validModelReportCertificateAnalysisQTests];