(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*TotalProteinQuantification: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeTotalProteinQuantification*)


(* ::Subsubsection:: *)
(*AnalyzeTotalProteinQuantification*)

DefineTests[AnalyzeTotalProteinQuantification,
	{
		Example[{Basic,"Given an Object[Protocol,TotalProteinQuantification], AnalyzeTotalProteinQuantification returns an Analysis Object:"},
			AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid]],
			ObjectP[Object[Analysis,TotalProteinQuantification]],
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
    Example[{Basic,"AnalyzeTotalProteinQuantification populates the StandardCurve,QuantificationSamples,AssaySamplesProteinConcentrations,SamplesInProteinConcentrations,SamplesInConcentrationDistributions, and InputSamplesSpectroscopyData fields:"},
      AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid]];
      First[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid][QuantificationAnalyses]][[{StandardCurve,QuantificationSamples,AssaySamplesProteinConcentrations,SamplesInProteinConcentrations,SamplesInConcentrationDistributions,InputSamplesSpectroscopyData}]],
      {
        LinkP[Object[Analysis, Fit]],
        {
          LinkP[Object[Sample]]..
        },
        {
          MassConcentrationP..
        },
        {
          MassConcentrationP..
        },
        {
          _DataDistribution..
        },
        {
          LinkP[Object[Data]]..
        }
      },
      SetUp:>(
        $CreatedObjects = {};

        (* Get rid of any changes to the protocol object from previous tests *)
        Upload[
         <|
           Object->Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],
           Replace[QuantificationAnalyses]->{}
         |>
        ]
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

		(* Option Unit Tests *)
		Example[{Options,UploadConcentration,"When UploadConcentration->True, AnalyzeTotalProteinQuantification updates the TotalProteinConcentration of the input protocol's SamplesIn:"},
			AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],UploadConcentration->True];
			Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid][SamplesIn][TotalProteinConcentration],
			{MassConcentrationP..},
			SetUp:>(
				$CreatedObjects = {};

				(* Get rid of any changes to the SamplesIn, WorkingSamples, and Protocol Objects from previous tests *)
				Upload[
					{
						<|
							Object -> Object[Sample, "Sample1"<>uuid],
							TotalProteinConcentration -> Null
						|>,
						<|
							Object -> Object[Sample, "Sample2"<>uuid],
							TotalProteinConcentration -> Null
						|>,
						<|
							Object -> Object[Sample, "Sample3"<>uuid],
							TotalProteinConcentration -> Null
						|>,
						<|
							Object -> Object[Sample, "Sample4"<>uuid],
							TotalProteinConcentration -> Null
						|>
					}
				]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,QuantificationWavelengths,"The QuantificationWavelengths Options specifies the wavelength(s) at which quantification analysis is performed to determine TotalProteinConcentration. If multiple wavelengths are specified, the absorbance or fluorescence values from the wavelengths are averaged for standard curve determination and quantification analysis:"},
			analysis=AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],QuantificationWavelengths->{555,600}*Nanometer];
			analysis[QuantificationWavelengths],
			{DistanceP..},
			Variables :> {analysis},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,StandardCurve,"Indicates the existing StandardCurve which absorbance or fluorescence data is compared to for TotalProteinConcentration quantification. If the StandardCurve option is set, the data from the input protocol's QuantificationSpectroscopyProtocol is not used to generate a standard curve:"},
			analysis=AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],StandardCurve->Object[Analysis,Fit,"Test Absorbance Fit Object for TotalProteinQuantification Tests"]];
			analysis[StandardCurve][Name],
			"Test Absorbance Fit Object for TotalProteinQuantification Tests",
			Variables :> {analysis},
			SetUp:>(
				$CreatedObjects = {};

				(* Get rid of any changes to the SamplesIn, WorkingSamples, and Protocol Objects from previous tests *)
				Upload[
					{
						<|
							Object -> Object[Sample, "Sample1"<>uuid],
							TotalProteinConcentration -> Null
						|>,
						<|
							Object -> Object[Sample, "Sample2"<>uuid],
							TotalProteinConcentration -> Null
						|>,
						<|
							Object -> Object[Sample, "Sample3"<>uuid],
							TotalProteinConcentration -> Null
						|>,
						<|
							Object -> Object[Sample, "Sample4"<>uuid],
							TotalProteinConcentration -> Null
						|>
					}
				]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,StandardCurveFitType,"Indicates which FitType (Sigmoid or Linear) is used to create the standard curve:"},
			analysis=AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],StandardCurveFitType->Linear];
			analysis[StandardCurve][ExpressionType],
			Linear,
			Variables :> {analysis},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Template,"The template analysis object whose methodology should be reproduced in running this analysis. Option values will be inherited from the template analysis object:"},
			AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],Template->Object[Analysis,TotalProteinQuantification,"Test Absorbance Analysis Object for AnalyzeTotalProteinQuantification Tests"]],
			ObjectP[Object[Analysis,TotalProteinQuantification]],
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Upload,"Indicates if the TotalProteinQuantification Analysis Object should be added to the database:"},
			AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],Upload->False],
			{PacketP[]..},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],

		(* Message Unit Tests *)
		Example[{Messages,"AnalyzeTPQInvalidQuantificationWavelengths","All members of the QuantificationWavelengths Option must be within the EmissionWavelengthRange when DetectionMode of the input protocol is Fluorescence:"},
			AnalyzeTotalProteinQuantification[Object[Protocol,TotalProteinQuantification,"Test FluorescenceQuantification TotalProteinQuantification Protocol"],QuantificationWavelengths->{400,600}*Nanometer,Upload->False],
			$Failed,
			Messages :> {
				Error::AnalyzeTPQInvalidQuantificationWavelengths,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AnalyzeTPQConflictingStandardCurveOptions","The StandardCurve and StandardCurveFitType Options cannot both be specified or both be Null:"},
			AnalyzeTotalProteinQuantification[Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],StandardCurve->Object[Analysis,Fit,"Test Absorbance Fit Object for TotalProteinQuantification Tests"],StandardCurveFitType->Sigmoid,Upload->False],
			$Failed,
			Messages :> {
				Error::AnalyzeTPQConflictingStandardCurveOptions,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AnalyzeTPQInvalidStandardCurveUnits","The Units of the provided StandardCurve must be compatible with the DetectionMode of the input protocol:"},
			AnalyzeTotalProteinQuantification[Object[Protocol,TotalProteinQuantification,"Test FluorescenceQuantification TotalProteinQuantification Protocol"],StandardCurve->Object[Analysis,Fit,"Test Absorbance Fit Object for TotalProteinQuantification Tests"],Upload->False],
			$Failed,
			Messages :> {
				Error::AnalyzeTPQInvalidStandardCurveUnits,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AnalyzeTPQInvalidProtocol","The input protocol must have a Status of Completed or Processing:"},
			AnalyzeTotalProteinQuantification[Object[Protocol,TotalProteinQuantification,"Test BCA TotalProteinQuantification Protocol"],Upload->False],
			$Failed,
			Messages :> {
				Error::AnalyzeTPQInvalidProtocol,
				Error::InvalidInput
			},
			SetUp:>(
				$CreatedObjects = {};

				Upload[
					<|
						Object->Object[Protocol,TotalProteinQuantification,"Test BCA TotalProteinQuantification Protocol"],
						Status->InCart
					|>
				];
			),
			TearDown :> (

				Upload[
					<|
						Object->Object[Protocol,TotalProteinQuantification,"Test BCA TotalProteinQuantification Protocol"],
						Status->Completed
					|>
				];

				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AnalyzeTPQPoorStandardCurveFit","If the R-squared value of the calculated standard curve is less than 0.95, a warning is thrown:"},
			AnalyzeTotalProteinQuantification[Object[Protocol,TotalProteinQuantification,"Test FluorescenceQuantification TotalProteinQuantification Protocol"],StandardCurveFitType->Linear,Upload->False],
			{PacketP[]..},
			Messages :> {
				Warning::AnalyzeTPQPoorStandardCurveFit
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AnalyzeTPQCalculatedConcentrationsExtrapolated","If the calculated TotalProteinConcentration is 0 mg/mL, or larger than the largest StandardCurveConcentration, a warning is thrown:"},
			AnalyzeTotalProteinQuantification[Object[Protocol,TotalProteinQuantification,"Test BCA TotalProteinQuantification Protocol"],StandardCurve->Object[Analysis, TotalProteinQuantification, "id:kEJ9mqR7KNPz"],Upload->False],
			{PacketP[]..},
			Messages :> {
				Warning::AnalyzeTPQCalculatedConcentrationsExtrapolated
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AnalyzeTPQConcentrationIncalculable","If a TotalProteinConcentration cannot be calculated from the spectroscopy data of an input sample and the StandardCurve's BestFitExpression, a warning is thrown:"},
			AnalyzeTotalProteinQuantification[Object[Protocol,TotalProteinQuantification,"Test FluorescenceQuantification TotalProteinQuantification Protocol"],StandardCurve->Object[Analysis,Fit,"Test FluorescenceQuantification Fit Analysis for AnalyzeTotalProteinQuantification Tests"],QuantificationWavelengths -> {520*Nanometer},Upload->False],
			{PacketP[]..},
			Messages :> {
				Warning::AnalyzeTPQConcentrationIncalculable,
				Warning::AnalyzeTPQCalculatedConcentrationsExtrapolated
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	},
	Variables:>{uuid},
	SymbolSetUp:>{
		
		uuid = CreateUUID[];
		
		$CreatedObjects={};
		
		Module[
			{
				resolvedOptions, spectrocopyData, standardCurveConcentrations, aliquotSamplePreparation,
				oneWayLinks, twoWayLinks, samples, samplesIn
			},
			
			(* helpers to create sample links *)
			createSample[uuid_, index_]:= Module[
				{
					tubePacket, tube1
				},
				tubePacket = <|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Site -> Link[$Site], DeveloperObject -> True
				|>;
				
				tube1 = Upload[tubePacket];
				
				ECL`InternalUpload`UploadSample[Model[Sample, "id:54n6evLdN3wB"], {"A1", tube1}, Name->"Sample"<>ToString[index]<>uuid]
			];
			
			createLinkedSamples[uuid_]:=Module[
				{
					mySamples, oneWayLinks, twoWayLinks
				},
				
				mySamples = Array[createSample[uuid, #]&,4];
				
				oneWayLinks = Link/@mySamples;
				
				twoWayLinks = Link[#, Protocols]&/@mySamples;
				
				{oneWayLinks, twoWayLinks}
			];
			
			resolvedOptions = {
				AssayType->Bradford,DetectionMode->Absorbance,Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],NumberOfReplicates->2,ProteinStandards->{Model[Sample,Protein,"id:8qZ1VW0498lR"],
				Model[Sample,Protein,"id:54n6evLdNa6v"],Model[Sample,Protein,"id:Y0lXejM9LD0W"],Model[Sample,Protein,"id:aXRlGn6kLj4B"],Model[Sample,Protein,"id:1ZA60vLnKk0E"],
				Model[Sample,Protein,"id:bq9LA0Jk57Or"],Model[Sample,Protein,"id:GmzlKjPXbpA5"]},ConcentratedProteinStandard->Null,StandardCurveConcentrations->Null,ProteinStandardDiluent->Null,
				StandardCurveBlank->Model[Sample,Chemical,"id:8qZ1VWNmdLBD"],StandardCurveReplicates->2,LoadingVolume->Quantity[5,"Microliters"],QuantificationReagent->Model[Sample,Chemical,"id:XnlV5jK89053"],
				QuantificationReagentVolume->Quantity[200,"Microliters"],QuantificationReactionTime->Null,QuantificationReactionTemperature->Null,ExcitationWavelength->Null,
				QuantificationWavelength->Quantity[595,"Nanometers"],QuantificationTemperature->Ambient,QuantificationTemperatureEquilibrationTime->Quantity[0,"Seconds"],NumberOfEmissionReadings->Null,
				EmissionReadLocation->Null,EmissionGain->Null,Cache->{Model[Sample,Protein,"id:54n6evLdN3wB"],Object[Sample,Protein,"id:n0k9mG8PwmJW"],Object[Sample,Protein,"id:01G6nvwRpnWm"],
				Object[Sample,Protein,"id:b64aFVuc5UsB"],Object[Container,Vessel,"id:cqDtBzQOS5Vz"],Object[Container,Vessel,"id:BAVvbFYyhAyU"],Object[Container,Vessel,"id:x659vTYxMPn1"]},
				FastTrack->False,Template->Null,ParentProtocol->Null,Operator->Null,Confirm->False,Name->Null,Upload->True,Output->Result,Email->Automatic,Incubate->{False,False},
				IncubationTemperature->{Null,Null},IncubationTime->{Null,Null},Mix->{Null,Null},MixType->{Null,Null},MixUntilDissolved->{Null,Null},MaxIncubationTime->{Null,Null},
				IncubationInstrument->{Null,Null},AnnealingTime->{Null,Null},IncubateAliquotContainer->{Automatic,Automatic},IncubateAliquotDestinationWell->{Null,Null},IncubateAliquot->{Null,Null},
				Centrifuge->{False,False},CentrifugeInstrument->{Null,Null},CentrifugeIntensity->{Null,Null},CentrifugeTime->{Null,Null},CentrifugeTemperature->{Null,Null},
				CentrifugeAliquotContainer->{Automatic,Automatic},CentrifugeAliquotDestinationWell->{Null,Null},CentrifugeAliquot->{Null,Null},Filtration->{False,False},
				FiltrationType->{Null,Null},FilterInstrument->{Null,Null},Filter->{Null,Null},FilterMaterial->{Null,Null},PrefilterMaterial->{Null,Null},FilterPoreSize->{Null,Null},
				PrefilterPoreSize->{Null,Null},FilterSyringe->{Null,Null},FilterHousing->{Null,Null},FilterIntensity->{Null,Null},FilterTime->{Null,Null},
				FilterTemperature->{Null,Null},FilterContainerOut->{Null,Null},FilterAliquotDestinationWell->{Null,Null},FilterAliquotContainer->{Automatic,Automatic},FilterAliquot->{Null,Null},
				FilterSterile->{Null,Null},Aliquot->{True,False},AliquotAmount->{Quantity[75,"Microliters"],Null},TargetConcentration->{Null,Null},AssayVolume->{Quantity[150,"Microliters"],Null},
				ConcentratedBuffer->{Null,Null},BufferDilutionFactor->{Null,Null},BufferDiluent->{Null,Null},AssayBuffer->{Model[Sample,Chemical,"id:8qZ1VWNmdLBD"],Null},
				AliquotSampleStorageCondition->{Null,Null},DestinationWell->{"A1","A1",Null,Null},AliquotContainer->{{1,Model[Container,Vessel,"2mL Tube"]},{2,Model[Container,Vessel,"2mL Tube"]},Null,Null},
				AliquotLiquidHandlingScale->MacroLiquidHandling,ConsolidateAliquots->False,MeasureWeight->False,MeasureVolume->False,ImageSample->False,SamplesInStorageCondition->{Null,Null},SubprotocolDescription->Null
			};
			spectrocopyData = {
				Link[Object[Data, AbsorbanceSpectroscopy, "id:vXl9j57Pw6bD"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:xRO9n3BPw6Yq"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:6V0npvmlOzYV"]],
				Link[Object[Data, AbsorbanceSpectroscopy, "id:9RdZXv1loEPa"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:mnk9jORrv6Xm"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:BYDOjvG6r89q"]],
				Link[Object[Data, AbsorbanceSpectroscopy, "id:M8n3rx06Z4dR"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:WNa4ZjKVGlW4"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:54n6evLmRozv"]],
				Link[Object[Data, AbsorbanceSpectroscopy, "id:n0k9mG8Pw64o"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:01G6nvwRp5oE"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:1ZA60vL54RNq"]],
				Link[Object[Data, AbsorbanceSpectroscopy, "id:Z1lqpMzR8Yd4"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:dORYzZJ3Db5b"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:eGakldJv6KXz"]],
				Link[Object[Data, AbsorbanceSpectroscopy, "id:pZx9jo8Pwm7E"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:4pO6dM5lqA9X"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:Vrbp1jK4Ozqe"]],
				Link[Object[Data, AbsorbanceSpectroscopy, "id:XnlV5jKXALD3"]], Link[Object[Data, AbsorbanceSpectroscopy, "id:qdkmxzqar6l4"]]
			};
			standardCurveConcentrations = {
				Quantity[0., "Milligrams"/"Milliliters"], Quantity[0.125, "Milligrams"/"Milliliters"], Quantity[0.25, "Milligrams"/"Milliliters"],
				Quantity[0.5, "Milligrams"/"Milliliters"], Quantity[0.75, "Milligrams"/"Milliliters"],
				Quantity[1., "Milligrams"/"Milliliters"], Quantity[1.5, "Milligrams"/"Milliliters"], Quantity[2., "Milligrams"/"Milliliters"]
			};
			aliquotSamplePreparation = {
				<|
					Aliquot -> True, AliquotAmount -> Quantity[75, "Microliters"], TargetConcentration -> Null, AssayVolume -> Quantity[0.15, "Milliliters"], AliquotContainer -> {1, Model[Container, Vessel, "2mL Tube"]},
					AssayBuffer -> Link[Model[Sample, "Milli-Q water"]], BufferDiluent -> Null, BufferDilutionFactor -> Null, ConcentratedBuffer -> Null, DestinationWell -> "A1", TargetConcentrationAnalyte -> Null,
					AliquotSampleLabel -> Null
				|>,
				<|
					Aliquot -> True, AliquotAmount -> Quantity[75, "Microliters"], TargetConcentration -> Null, AssayVolume -> Quantity[0.15, "Milliliters"], AliquotContainer -> {2, Model[Container, Vessel, "2mL Tube"]},
					AssayBuffer -> Link[Model[Sample, "Milli-Q water"]], BufferDiluent -> Null, BufferDilutionFactor -> Null, ConcentratedBuffer -> Null, DestinationWell -> "A1", TargetConcentrationAnalyte -> Null,
					AliquotSampleLabel -> Null
				|>,
				<|
					Aliquot -> False, AliquotAmount -> Null, TargetConcentration -> Null, AssayVolume -> Null, AliquotContainer -> Null, AssayBuffer -> Null, BufferDiluent -> Null,
					BufferDilutionFactor -> Null, ConcentratedBuffer -> Null, DestinationWell -> Null, TargetConcentrationAnalyte -> Null, AliquotSampleLabel -> Null
				|>,
				<|
					Aliquot -> False, AliquotAmount -> Null, TargetConcentration -> Null, AssayVolume -> Null, AliquotContainer -> Null, AssayBuffer -> Null, BufferDiluent -> Null,
					BufferDilutionFactor -> Null, ConcentratedBuffer -> Null, DestinationWell -> Null, TargetConcentrationAnalyte -> Null, AliquotSampleLabel -> Null
				|>
			};
				
			(* create links *)
			{oneWayLinks, twoWayLinks} = createLinkedSamples[uuid];
			samples = oneWayLinks;
			samplesIn = twoWayLinks;
			
			Upload[<|
				Type->Object[Protocol, TotalProteinQuantification],
				Name->"Test Protocol TotalProteinQuantification" <> uuid,
				Status->Completed,
				Replace[AliquotSamplePreparation]->aliquotSamplePreparation,
				AssayType->Bradford,
				DetectionMode -> Absorbance,
				Replace@AliquotSamples->samples,
				Replace@SamplesIn->samplesIn,
				Replace@WorkingSamples->samples,
				StandardCurveReplicates -> 2,
				LoadingVolume-> Quantity[5., "Microliters"],
				NumberOfReplicates->2,
				QuantificationPlate -> Link[Object[Container, Plate, "id:o1k9jAGPamx8"]],
				QuantificationReagentVolume -> Quantity[200., "Microliters"],
				QuantificationSpectroscopyProtocol -> Link[Object[Protocol, AbsorbanceSpectroscopy, "id:M8n3rx06Z7WO"]],
				Replace@QuantificationWavelengths -> {Quantity[595., "Nanometers"]},
				ResolvedOptions -> resolvedOptions,
				Replace@SpectroscopyData -> spectrocopyData,
				Replace@StandardCurveConcentrations -> standardCurveConcentrations,
				Status->Completed,
				Replace@QuantificationAnalyses -> {},
				Replace[ContainersIn] -> {Link[Object[Container, Vessel, "id:XnlV5jKpROV3"], Protocols], Link[Object[Container, Vessel, "id:N80DNj14pk5q"], Protocols]},
				QuantificationReagent -> Link[Object[Sample, "id:N80DNj16dObk"]]
			|>]
		]
	},
	SymbolTearDown:> {
		Module[{allObjects, existingObjects, objectsToErase},
			
			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects = {
				Object[Protocol, TotalProteinQuantification, "Test Protocol TotalProteinQuantification" <> uuid],
				Object[Sample, "Sample1"<>uuid],
				Object[Sample, "Sample2"<>uuid],
				Object[Sample, "Sample3"<>uuid],
				Object[Sample, "Sample4"<>uuid]
			};
			
			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];
			
			objectsToErase = Join[$CreatedObjects, existingObjects];
			
			(*Erase all the created objects and models*)
			Quiet[EraseObject[objectsToErase, Force -> True, Verbose -> False]];
			
			Unset[$CreatedObjects]
		
		]
	}
];


(* ::Subsubsection:: *)
(*AnalyzeTotalProteinQuantificationOptions*)

DefineTests[AnalyzeTotalProteinQuantificationOptions,
	{
		Example[{Basic,"Display the option values which will be used in the analysis:"},
			AnalyzeTotalProteinQuantificationOptions[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"]],
			_Grid,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			AnalyzeTotalProteinQuantificationOptions[Object[Protocol,TotalProteinQuantification,"Test FluorescenceQuantification TotalProteinQuantification Protocol"],QuantificationWavelengths->{400,600}*Nanometer],
			_Grid,
			Messages:>{
				Error::AnalyzeTPQInvalidQuantificationWavelengths,
				Error::InvalidOption
			},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			AnalyzeTotalProteinQuantificationOptions[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"],OutputFormat->List],
			{(_Rule|_RuleDelayed)..},
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	}
];


(* ::Subsubsection:: *)
(*AnalyzeTotalProteinQuantificationPreview*)

DefineTests[AnalyzeTotalProteinQuantificationPreview,
	{
		Example[{Basic,"Given an input protocol, AnalyzeTotalProteinQuantificationPreview outputs a TabView showing the StandardCurve and the TotalProteinConcentrations :"},
			AnalyzeTotalProteinQuantificationPreview[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"]],
			_TabView,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"If you wish to understand how the Analysis will be performed, try using AnalyzeTotalProteinQuantificationOptions:"},
			AnalyzeTotalProteinQuantificationOptions[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"]],
			_Grid,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidAnalyzeTotalProteinQuantificationQ:"},
			ValidAnalyzeTotalProteinQuantificationQ[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"]],
			True,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	}
];


(* ::Subsubsection:: *)
(*ValidAnalyzeTotalProteinQuantificationQ*)

DefineTests[ValidAnalyzeTotalProteinQuantificationQ,
	{
		Example[{Basic,"Verify that the analysis can be run without issues:"},
			ValidAnalyzeTotalProteinQuantificationQ[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"]],
			True,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidAnalyzeTotalProteinQuantificationQ[Object[Protocol,TotalProteinQuantification,"Test FluorescenceQuantification TotalProteinQuantification Protocol"],QuantificationWavelengths->{400,600}*Nanometer],
			False,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidAnalyzeTotalProteinQuantificationQ[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"],OutputFormat->TestSummary],
			_EmeraldTestSummary,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidAnalyzeTotalProteinQuantificationQ[Object[Protocol,TotalProteinQuantification,"Test Bradford TotalProteinQuantification Protocol"],Verbose->True],
			True,
			SetUp:>(
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	}
];


(* ::Section:: *)
(*End Test Package*)
