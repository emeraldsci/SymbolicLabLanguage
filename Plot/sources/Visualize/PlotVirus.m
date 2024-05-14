(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotVirus*)


DefineOptions[PlotVirus,
	Options :> {
		ModifyOptions[ListPlotOptions,{OptionName->ImageSize,Default->500}],
		OutputOption
	}
];

(* Messages *)
Error::FieldDoesntExist="The ReferenceImages field does not exist for the composition of the virus sample object `1`.";


(* Primary overload *)
PlotVirus[virus:PacketP[Model[Sample]],ops:OptionsPattern[PlotVirus]]:=Module[
	{
		originalOps,safeOps,output,virusModelImages,plot
	},

	(* Original options as a list *)
	originalOps=ToList[ops];

	(* Fill in missing options values with defaults *)
	safeOps=SafeOptions[PlotVirus,originalOps];

	(* Requested output for command builder *)
	output=Lookup[safeOps,Output];

	(* Throw an error if the reference images are not found *)
	virusModelImages=
		Quiet[
			Check[
				Flatten@Download[virus,Composition[[All,2]]][ReferenceImages],
				Message[Error::FieldDoesntExist,virus];Return[$Failed],
				{Download::FieldDoesntExist}
			],
			Download::FieldDoesntExist
		];

	virusModelImages=Replace[virusModelImages,{}->Null];

	(* if there's an image in the SLLinfo packet, resize it and display it.  otherwise return null. *)
	plot=If[NullQ[virusModelImages],
		Null,
		ImageCollage[Switch[
			#,
			ObjectP[Object[EmeraldCloudFile]],
			ImageResize[ImportCloudFile[#],Lookup[safeOps,ImageSize]],
			ObjectP[Object[Data]],
			ImageResize[#,Lookup[safeOps,ImageSize]]
		]&/@virusModelImages]
	];

	(* Return requested outputs only *)
	output/.{
		Result->plot,
		Preview->plot,
		Options->safeOps,
		Tests->{}
	}

];

(* --- SLL Object --- *)
PlotVirus[virus:ObjectReferenceP[Model[Sample]],ops:OptionsPattern[PlotVirus]]:=
	PlotVirus[Download[virus],ops];


PlotVirus[objs:{ObjectP[]..},ops:OptionsPattern[]]:=Map[PlotVirus[#,ops]&,Download[objs]];
