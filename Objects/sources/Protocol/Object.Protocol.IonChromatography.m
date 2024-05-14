(* ::Package:: *)

DefineObjectType[Object[Protocol, IonChromatography], {
	Description->"A set of parameters describing the separation of electrically charged species using Ion Chromatography.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* --- Instrument Information --- *)
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			Description->"The device containing a pump, column oven, and detector(s) that executes this experiment.",
			Category->"General"
		},
		AnalysisChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AnalysisChannelP,
			Description->"For each member of SamplesIn, the flow path into which each sample is injected, either cation or anion channel. Cation channel employs negatively-charged stationary phase to separate positively charged species, whereas anion channel employs positively-charged stationary phase to separate negatively charge species.",
			IndexMatching->SamplesIn,
			Category->"General",
			Abstract->True
		},
		AnionSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"A list of samples that are injected into the anion channel of the instrument for separation and analysis.",
			Category->"General"
		},
		CationSamples->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"A list of samples that are injected into the anion channel of the instrument for separation and analysis.",
			Category->"General"
		},
		ChannelSelection->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AnalysisChannelP,
			Description->"A list of all independent flow paths used in this protocol.",
			Category->"General",
			Abstract->True
		},
		AnionColumn->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item], Model[Item]],
			Description->"The device with resin through which the buffer and input samples flow for anion channel. It adsorbs and separates charged molecules within the sample based on the properties of the eluent, Samples, and ColumnTemperature.",
			Category->"General",
			Abstract->True
		},
		CationColumn->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item], Model[Item]],
			Description->"The device with resin through which the buffer and input samples flow for cation channel. It adsorbs and separates charged molecules within the sample based on the properties of the Buffers, Samples, and ColumnTemperature.",
			Category->"General",
			Abstract->True
		},
		Column->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item],Model[Item]],
			Description->"The device with resin through which the buffer and input samples flow. It adsorbs and separates charged molecules within the sample based on the properties of the Buffers, Samples, and ColumnTemperature.",
			Category->"General",
			Abstract->True
		},
		AnionGuardColumn->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item], Model[Item]],
			Description->"A protective device placed in the flow path before the AnionColumn in order to adsorb fouling contaminants and, thus, preserve the AnionColumn lifetime.",
			Category->"General",
			Abstract->True
		},
		CationGuardColumn->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item],Model[Item]],
			Description->"A protective device placed in the flow path before the CationColumn in order to adsorb fouling contaminants and, thus, preserve the CationColumn lifetime.",
			Category->"General",
			Abstract->True
		},
		GuardColumn->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item],Model[Item]],
			Description->"A protective device placed in the flow path before the Column in order to adsorb fouling contaminants and, thus, preserve the Column lifetime.",
			Category->"General",
			Abstract->True
		},
		AnionSuppressor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Part],Model[Part]],
			Description->"A device place in the flow path before the AnionDetector to reduce the conductivity from the buffer or eluent by chemically converting high ionic strength buffer or eluent to water.",
			Category->"General",
			Developer->True
		},
		CationSuppressor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Part],Model[Part]],
			Description->"A device place in the flow path before the CationDetector to reduce the conductivity from the buffer or eluent by chemically converting high ionic strength buffer or eluent to water.",
			Category->"General",
			Developer->True
		},
		AnionDetector->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyDetectorTypeP,
			Description->"The types of measurements performed for the experiment and available on the Instrument for anion channel.",
			Category->"General",
			Abstract->True
		},
		CationDetector->{
			Format->Single,
			Class->Expression,
			Pattern:>IonChromatographyDetectorTypeP,
			Description->"The types of measurements performed for the experiment and available on the Instrument for cation channel.",
			Category->"General",
			Abstract->True
		},
		Detectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>IonChromatographyDetectorTypeP,
			Description->"The type of measurement to run on the separated analytes that generates quantifiable signals for the chromatogram.",
			Category->"General",
			Abstract->True
		},
		SeparationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Second],
			Units->Minute,
			Description->"The estimated completion time for the protocol.",
			Category->"General",
			Developer->True
		},
		
		(* --- Cleaning --- *)
		TubingRinseSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solution used to rinse buffers lines before and after and the experiment.",
			Category->"Cleaning"
		},
		NeedleWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solution used to wash the injection needle and pumps before, during, and after the experiment.",
			Category->"Cleaning",
			Abstract->True
		},
		PurgeWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect purged buffer liquid.",
			Category -> "Cleaning",
			Developer -> True
		},
		CapWashAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing],
				Model[Plumbing]
			],
			Description -> "Buffer cap plumbing adapter used to clean the tubing interior of used buffer caps.",
			Category -> "Cleaning"
		},

		(*--- Column Installation Information ---*)
		AnionColumnConnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description->"Information for attaching columns to the flow path for anion channel.",
			Headers->{"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category->"Column Installation",
			Developer->True
		},
		CationColumnConnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description->"Information for attaching columns to the flow path for cation channel.",
			Headers->{"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category->"Column Installation",
			Developer->True
		},
		ColumnConnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description->"Information for attaching columns to the flow path coming from the sample manager.",
			Headers->{"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category->"Column Installation",
			Developer->True
		},
		AnionColumnDisconnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description->"Information for disconnecting column joins prior to detaching columns from the flow path for anion channel.",
			Headers->{"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category->"Column Installation",
			Developer->True
		},
		CationColumnDisconnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description->"Information for disconnecting column joins prior to detaching columns from the flow path for cation channel.",
			Headers->{"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category->"Column Installation",
			Developer->True
		},
		AnionColumnJoinConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing],Null,Object[Item,Column],Null},
			Description->"The connection information for attaching columns joins to the flow path of anion channel.",
			Headers->{"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category->"Column Installation",
			Developer->True
		},
		CationColumnJoinConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing],Null,Object[Item,Column],Null},
			Description->"The connection information for attaching columns joins to the flow path of cation channel.",
			Headers->{"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category->"Column Installation",
			Developer->True
		},
		ColumnJoinConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing],Null,Object[Item,Column],Null},
			Description->"The connection information for attaching columns joins to the flow path.",
			Headers->{"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category->"Column Installation",
			Developer->True
		},
		ColumnDisconnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description->"Information for disconnecting column joins prior to detaching columns from the flow path coming from the sample manager.",
			Headers->{"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category->"Column Installation",
			Developer->True
		},
		ColumnDisconnectionSlot->{
			Format->Single,
			Class->{Link,String},
			Pattern:>{_Link,_String},
			Relation->{Model[Container]|Object[Container],Null},
			Description->"The destination information for the disconnected column joins.",
			Headers->{"Container","Position"},
			Category->"Column Installation",
			Developer->True
		},
				
		(* --- Buffers --- *)
		EluentGeneratorInletSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent pumped to the eluent generator in the flow path of anion channel for electrolysis.",
			Category->"General",
			Abstract->True
		},
		Eluent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The solvent generated in the flow path of anion channel from electrolysis of the inlet solution.",
			Category->"General",
			Abstract->True
		},
		BufferA->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent pumped through channel A of the flow path in cation channel.",
			Category->"General",
			Abstract->True
		},
		BufferB->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent pumped through channel B of the flow path in cation channel.",
			Category->"General",
			Abstract->True
		},
		BufferC->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent pumped through channel C of the flow path in cation channel.",
			Category->"General",
			Abstract->True
		},
		BufferD->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent pumped through channel D of the flow path in cation channel.",
			Category->"General",
			Abstract->True
		},
		EluentGeneratorInletSolutionCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description->"The cap used to aspirate eluent generator inlet solution into the flow path during this protocol.",
			Category->"General"
		},
		BufferACap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description->"The cap used to aspirate Buffer A into the flow path during this protocol.",
			Category->"General"
		},
		BufferBCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description->"The cap used to aspirate Buffer B into the flow path during this protocol.",
			Category->"General"
		},
		BufferCCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description->"The cap used to aspirate Buffer C into the flow path during this protocol.",
			Category->"General"
		},
		BufferDCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description->"The cap used to aspirate Buffer D into the flow path during this protocol.",
			Category->"General"
		},
		NeedleWashSolutionCap->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Item,Cap], Model[Item,Cap]],
			Description->"The cap used to aspirate needle was solution into the autosampler during this protocol.",
			Category->"General"
		},
 		BufferCapConnections->{
			Format->Multiple,
			Class->{Link, String, Link, String},
			Pattern:>{_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation->{Object[Item,Cap], Null, Object[Container], Null},
			Description->"The instructions for attaching the caps to the Buffer containers.",
			Category->"General",
			Headers->{"Buffer Cap", "Cap Threads", "Buffer Container", "Buffer Container Spout"},
			Developer->True
		},
		BufferContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container],Null},
			Description->"A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category->"General",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		InitialInletSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of deionized water in the reservoir immediately before the experiment was started. Deionized water from the reservoir is electrolysed to generate buffer in the flow path via a eluent generator.",
			Category->"General"
		},
		InitialBufferAVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of Buffer A in the reservoir immediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferBVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of  Buffer B in the reservoir immediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferCVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of Buffer C in the reservoir immediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferDVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of  Buffer D in the reservoir immediately before the experiment was started.",
			Category->"General"
		},
		InitialNeedleWashSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of NeedleWashSolution in the reservoir immediately before the experiment was started.",
			Category->"General"
		},
		InitialInletSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of the water reservoir immediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferAAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of Buffer A immediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferBAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of Buffer B immediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferCAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of Buffer Cimmediately before the experiment was started.",
			Category->"General"
		},
		InitialBufferDAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of Buffer D immediately before the experiment was started.",
			Category->"General"
		},
		InitialNeedleWashSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image taken of NeedleWashSolution immediately before the experiment was started.",
			Category->"General"
		},
		
		(* --Injection Sequence and Gradient Information -- *)
		EluentGradient->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Millimolar, 100 Millimolar]}...}|RangeP[0 Millimolar, 100 Millimolar]),
			Description->"For each member of AnionSamples, the eluent concentration over time, in the form: {Time, eluent concentration in Millimolar} or a single eluent concentration for the entire run.",
			IndexMatching->AnionSamples,
			Category->"Gradient"
		},
		CationGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationSamples, the percentage of BufferA in the composition over time, in the form: {Time, % BufferA} or a single % BufferA for the entire run.",
			IndexMatching->CationSamples,
			Category->"Gradient"
		},
		CationGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationSamples, the percentage of BufferB in the composition over time, in the form: {Time, % BufferB} or a single % BufferB for the entire run.",
			IndexMatching->CationSamples,
			Category->"Gradient"
		},
		CationGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationSamples, the percentage of BufferC in the composition over time, in the form: {Time, % BufferC} or a single % BufferC for the entire run.",
			IndexMatching->CationSamples,
			Category->"Gradient"
		},
		CationGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationSamples, the percentage of BufferD in the composition over time, in the form: {Time, % BufferD} or a single % BufferD for the entire run.",
			IndexMatching->CationSamples,
			Category->"Gradient"
		},
		GradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of SamplesIn, the percentage of BufferA in the composition over time, in the form: {Time, % BufferA} or a single % BufferA for the entire run.",
			IndexMatching->SamplesIn,
			Category->"Gradient"
		},
		GradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of SamplesIn, the percentage of BufferB in the composition over time, in the form: {Time, % BufferB} or a single % BufferB for the entire run.",
			IndexMatching->SamplesIn,
			Category->"Gradient"
		},
		GradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of SamplesIn, the percentage of BufferC in the composition over time, in the form: {Time, % BufferC} or a single % BufferC for the entire run.",
			IndexMatching->SamplesIn,
			Category->"Gradient"
		},
		GradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of SamplesIn, the percentage of BufferD in the composition over time, in the form: {Time, % BufferD} or a single % BufferD for the entire run.",
			IndexMatching->SamplesIn,
			Category->"Gradient"
		},
		AnionGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method, IonChromatographyGradient],
			Description->"For each member of AnionSamples, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->AnionSamples,
			Category->"Gradient"
		},
		CationGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each member of CationSamples, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->CationSamples,
			Category->"Gradient"
		},
		GradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Gradient],
			Description->"For each member of SamplesIn, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->SamplesIn,
			Category->"Gradient"
		},
		AnionFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of AnionSamples, the total rate of mobile phase pumped through the instrument in anion channel.",
			IndexMatching->AnionSamples,
			Category->"Gradient",
			Abstract->True
		},
		CationFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of CationSamples, the total rate of mobile phase pumped through the instrument in cation channel.",
			IndexMatching->CationSamples,
			Category->"Gradient",
			Abstract->True
		},
		FlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of SamplesIn, the total rate of mobile phase pumped through the instrument.",
			IndexMatching->SamplesIn,
			Category->"Gradient",
			Abstract->True
		},
		AnionSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of AnionSamples, the physical quantity taken from the sample and injected onto the column.",
			IndexMatching->AnionSamples,
			Category->"Sample Preparation",
			Abstract->True
		},
		CationSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of CationSamples, the physical quantity taken from the sample and injected onto the column.",
			IndexMatching->CationSamples,
			Category->"Sample Preparation",
			Abstract->True
		},
		SampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of SamplesIn, the physical quantity taken from the sample and injected onto the column.",
			IndexMatching->SamplesIn,
			Category->"Sample Preparation",
			Abstract->True
		},
		AnionColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionSamples, the nominal temperature of the column compartment during a run for anion channel.",
			IndexMatching->AnionSamples,
			Category->"Gradient",
			Abstract->True
		},
		CationColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of CationSamples, the nominal temperature of the column compartment during a run for anion channel.",
			IndexMatching->CationSamples,
			Category->"Gradient",
			Abstract->True
		},
		ColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of SamplesIn, the nominal temperature of the column compartment during a run.",
			IndexMatching->SamplesIn,
			Category->"Gradient",
			Abstract->True
		},
		AnionInjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				AnalysisChannel->Expression,
				InjectionVolume->Real,
				Gradient->Link,
				DilutionFactor->Real, (* From Aliquot *)
				ColumnTemperature->Real,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->ObjectP[{Object[Sample], Model[Sample]}],
				AnalysisChannel->AnalysisChannelP,
				InjectionVolume->GreaterEqualP[0*Micro*Liter],
				Gradient->ObjectP[Object[Method]],
				DilutionFactor->GreaterP[0],
				ColumnTemperature->GreaterP[0*Celsius],
				Data->_Link
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[Object[Sample], Model[Sample]],
				AnalysisChannel->Null,
				InjectionVolume->Null,
				Gradient->Object[Method],
				DilutionFactor->Null,
				ColumnTemperature->Null,
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				AnalysisChannel->None,
				InjectionVolume->Micro Liter,
				Gradient->None,
				DilutionFactor->None,
				ColumnTemperature->Celsius,
				Data->None
			},
			Description->"The sequence of samples injected into the anion channel for a given experiment run including for ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category->"General"
		},
		CationInjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				AnalysisChannel->Expression,
				InjectionVolume->Real,
				Gradient->Link,
				DilutionFactor->Real, (* From Aliquot *)
				ColumnTemperature->Real,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->ObjectP[{Object[Sample], Model[Sample]}],
				AnalysisChannel->AnalysisChannelP,
				InjectionVolume->GreaterEqualP[0*Micro*Liter],
				Gradient->ObjectP[Object[Method]],
				DilutionFactor->GreaterP[0],
				ColumnTemperature->GreaterP[0*Celsius],
				Data->_Link
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[Object[Sample], Model[Sample]],
				AnalysisChannel->Null,
				InjectionVolume->Null,
				Gradient->Object[Method],
				DilutionFactor->Null,
				ColumnTemperature->Null,
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				AnalysisChannel->None,
				InjectionVolume->Micro Liter,
				Gradient->None,
				DilutionFactor->None,
				ColumnTemperature->Celsius,
				Data->None
			},
			Description->"The sequence of samples injected into the cation channel for a given experiment run including for ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category->"General"
		},
		ElectrochemicalInjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				InjectionVolume->Real,
				Gradient->Link,
				DilutionFactor->Real, (* From Aliquot *)
				ColumnTemperature->Real,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->ObjectP[{Object[Sample], Model[Sample]}],
				InjectionVolume->GreaterEqualP[0*Micro*Liter],
				Gradient->ObjectP[Object[Method]],
				DilutionFactor->GreaterP[0],
				ColumnTemperature->GreaterP[0*Celsius],
				Data->_Link
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[Object[Sample], Model[Sample]],
				InjectionVolume->Null,
				Gradient->Object[Method],
				DilutionFactor->Null,
				ColumnTemperature->Null,
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				InjectionVolume->Micro Liter,
				Gradient->None,
				DilutionFactor->None,
				ColumnTemperature->Celsius,
				Data->None
			},
			Description->"The sequence of samples injected into the instrument for a given experiment run including for ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category->"General"
		},
		AnionSuppressorMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each member of AnionSamples, the operation method of the anion suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			IndexMatching->AnionSamples,
			Category->"Detection"
		},
		AnionSuppressorVoltage->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each member of AnionSamples, the electrical potential difference applied to the Anion Suppressor.",
			IndexMatching->AnionSamples,
			Category->"Detection"
		},
		AnionSuppressorCurrent->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each member of AnionSamples, the rate of electric charge flow between the electrodes in the suppressor for anion channel.",
			IndexMatching->AnionSamples,
			Category->"Detection"
		},
		CationSuppressorMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each member of CationSamples, the operation method of the cation suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			IndexMatching->CationSamples,
			Category->"Detection"
		},
		CationSuppressorVoltage->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each member of CationSamples, the electrical potential difference applied to the Cation Suppressor.",
			IndexMatching->CationSamples,
			Category->"Detection"
		},
		CationSuppressorCurrent->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each member of CationSamples, the rate of electric charge flow between the electrodes in the suppressor for cation channel.",
			IndexMatching->CationSamples,
			Category->"Detection"
		},
		AnionDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionSamples, the temperature of the cell where conducutivity measurement is collected for anion channel.",
			IndexMatching->AnionSamples,
			Category->"Detection"
		},
		CationDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionSamples, the temperature of the cell where conducutivity measurement is collected for cation channel.",
			IndexMatching->AnionSamples,
			Category->"Detection"
		},
		AbsorbanceWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Centimeter],
			Units->Nanometer,
			Description->"For each member of SamplesIn, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		AbsorbanceSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units->1/Second,
			Description->"For each member of SamplesIn, indicates the frequency of measurement for UVVis at all specified wavelengths of light.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		ElectrochemicalDetectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ElectrochemicalDetectionModeP,
			Description->"For each member of SamplesIn, the mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		WorkingElectrode->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item,Electrode],Object[Item,Electrode]],
			Description->"The electrode where the analytes undergo reduction or oxidation recations due to the potential difference applied.",
			Category->"Detection"
		},
		ReferenceElectrode->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Part,ReferenceElectrode],Object[Part,ReferenceElectrode]],
			Description->"For each member of SamplesIn, the combination pH-Ag/AgCl reference electrode that is used to either monitor the pH of the flow cell or to serve as a reference with a constant potential during measurement.",
			Category->"Detection"
		},
		ReferenceElectrodeMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ReferenceElectrodeModeP,
			Description->"For each member of SamplesIn, the mode of operation of the reference electrode either to monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference).",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		VoltageProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], VoltageP}...}|VoltageP),
			Description->"For each member of SamplesIn, the time-dependent voltage setting throughout the measurement.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		WaveformProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Minute],ObjectP[Object[Method,Waveform]]}...}|ObjectP[Object[Method,Waveform]],
			Description->"For each member of SamplesIn, a series of time-dependent voltage setting (waveform) that will be repeated over the entire duration of the analysis.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		WaveformObjects->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Waveform],
			Description->"The waveform method objects used during the detection.",
			Category->"Detection"
		},
		ElectrochemicalSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0/Second],
			Units->1/Second,
			Description->"For each member of SamplesIn, indicates the frequency of amperometric measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		DetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"For each member of SamplesIn, the temperature of the detection oven where the eletrochemical detection takes place.",
			IndexMatching->SamplesIn,
			Category->"Detection"
		},
		pHCalibration->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates whether the reference electrode in the flow cell is calibrated prior to running samples.",
			Category->"Detection"
		},
		NeutralpHCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The solution with a neutral pH (pH=7) used during the pH electrode calibration.",
			Category->"Detection"
		},
		SecondarypHCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The additional solution, either acidic or basic, used to create the second point on the pH calibration curve.",
			Category->"Detection"
		},
		SecondarypHCalibrationBufferTarget->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14,1],
			Description->"The expected pH value of the additional solution used in the pH electrode calibration.",
			Category->"Detection"
		},

		WorkingElectrodeStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The conditions under which WorkingElectrode used by this experiment should be stored after the protocol is completed.",
			Category->"Detection"
		},
		BufferAStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The conditions under which BufferA used by this experiment should be stored after the protocol is completed.",
			Category->"General"
		},
		BufferBStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The conditions under which BufferB used by this experiment should be stored after the protocol is completed.",
			Category->"General"
		},
		BufferCStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The conditions under which BufferC used by this experiment should be stored after the protocol is completed.",
			Category->"General"
		},
		BufferDStorageCondition->{
			Format->Single,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"The conditions under which BufferD used by this experiment should be stored after the protocol is completed.",
			Category->"General"
		},

		SequenceName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name for the queue file for the Instrument software.",
			Category->"General",
			Developer->True
		},
		SequenceDirectory->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The directory for the queue file.",
			Category->"General",
			Developer->True
		},
		ExperimentFilePaths->{
			Format->Multiple,
			Class->String,
			Pattern:>FilePathP,
			Description->"The files used to execute the IonChromatography runs.",
			Category->"General",
			Developer->True
		},
		AnionWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the protocol imported onto the system for anion channel.",
			Category->"General",
			Developer->True
		},
		CationWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the protocol imported onto the system for anion channel.",
			Category->"General",
			Developer->True
		},
		WorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the protocol imported onto the system.",
			Category->"General",
			Developer->True
		},
		AnionImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for anion channel.",
			Category->"General",
			Developer->True
		},
		CationImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for cation channel.",
			Category->"General",
			Developer->True
		},
		ImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software.",
			Category->"General",
			Developer->True
		},
		AnionImportDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory to which all import files will be written for anion channel.",
			Category->"General",
			Developer->True
		},
		CationImportDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory to which all import files will be written for cation channel.",
			Category->"General",
			Developer->True
		},
		ImportDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory to which all import files will be written.",
			Category->"General",
			Developer->True
		},

		(*--Autosampler information--*)
		SampleTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the chamber where input samples are incubated in prior to injection on the column.",
			Category->"Sample Preparation"
		},
		AutosamplerDeckPlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]), Null},
			Description->"List of autosampler container deck placements.",
			Category->"General",
			Developer->True,
			Headers->{"Object to Place", "Placement Tree"}
		},
		AutosamplerRackPlacements->{
			Format->Multiple,
			Class->{Link,Link,Expression},
			Pattern:>{_Link, _Link, LocationPositionP},
			Relation->{(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]), (Object[Container]|Object[Sample]|Model[Container]|Model[Sample]), Null},
			Description->"List of autosampler container rack placements.",
			Category->"General",
			Developer->True,
			Headers->{"Object to Place", "Destination Object", "Destination Position"}
		},
		PlateSeal->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample], Object[Item], Model[Item]],
			Description->"The package of piercable, adhesive film used to cover plates of injection samples in this experiment in order to mitigate sample evaporation.",
			Category->"Sample Preparation",
			Abstract->False
		},

		(*--- Standards ---*)
		Standards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"Samples with known profiles used to calibrate peak integrations and retention times for a given run.",
			Category->"Standards"
		},
		StandardAnalysisChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AnalysisChannelP,
			Description->"For each member of Standards, the flow path into which the standard is injected, either cation or anion channel.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		AnionStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"Samples with known profiles that are injected into the anion channel of the instrument.",
			Category->"Standards"
		},
		CationStandards->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"Samples with known profiles that are injected into the cation channel of the instrument.",
			Category->"Standards"
		},
		AnionStandardSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of AnionStandards, the physical quantity taken from the standard and injected onto the column.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		CationStandardSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of CationStandards, the physical quantity taken from the standard and injected onto the column.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		StandardSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of Standards, the physical quantity taken from the standard and injected onto the column.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		AnionStandardColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionStandards, the nominal temperature of the column compartment during a run for anion channel.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		CationStandardColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of CationStandards, the nominal temperature of the column compartment during a run for cation channel.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		StandardColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of Standards, the nominal temperature of the column compartment during a run.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardEluentGradient->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Millimolar, 100 Millimolar]}...}|RangeP[0 Millimolar, 100 Millimolar]),
			Description->"For each member of AnionStandards, the eluent concentration over time, in the form: {Time, eluent concentration in Millimolar} or a single eluent concentration for the entire run.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		AnionStandardFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of AnionStandards, the total rate of mobile phase pumped through the instrument in anion channel.",
			IndexMatching->AnionStandards,
			Category->"Standards",
			Abstract->True
		},
		CationStandardGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationStandards, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		CationStandardGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of CationStandards, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		CationStandardGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationStandards, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		CationStandardGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of CationStandards, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		CationStandardFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of CationStandards, the total rate of mobile phase pumped through the instrument in cation channel.",
			IndexMatching->CationStandards,
			Category->"Standards",
			Abstract->True
		},
		StandardGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of Standards, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of Standards, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of Standards, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of Standards, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of Standards, the total rate of mobile phase pumped through the instrument.",
			IndexMatching->Standards,
			Category->"Standards",
			Abstract->True
		},
		AnionStandardGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each member of AnionStandards, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		CationStandardGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each member of CationStandards, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		StandardGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Gradient],
			Description->"For each member of Standards, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		AnionStandardSuppressorMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each member of AnionStandards, the operation method of the anion suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		AnionStandardSuppressorVoltage->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each member of AnionStandards, the electrical potential difference applied to the Anion Suppressor..",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		AnionStandardSuppressorCurrent->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each member of AnionStandards, the rate of electric charge flow between the electrodes in the suppresor during the run for anion channel.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		CationStandardSuppressorMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each member of CationStandards, the operation method of the cation suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		CationStandardSuppressorVoltage->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each member of CationStandards, the electrical potential difference applied to the Cation Suppressor.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		CationStandardSuppressorCurrent->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each member of CationStandards, the rate of electric charge flow between the electrodes in the suppresor during the run for cation channel.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		AnionStandardDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionStandards, the temperature of the cell where conductivity is measured in the anion channel.",
			IndexMatching->AnionStandards,
			Category->"Standards"
		},
		CationStandardDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of CationStandards, the temperature of the cell where conductivity is measured in the cation channel.",
			IndexMatching->CationStandards,
			Category->"Standards"
		},
		StandardsStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of Standards, the storage conditions under which the standard samples should be stored after the protocol is completed.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardAbsorbanceWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Centimeter],
			Units->Nanometer,
			Description->"For each member of Standards, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardAbsorbanceSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units->1/Second,
			Description->"For each member of Standards, indicates the frequency of measurement for UVVis at all specified wavelengths of light.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardElectrochemicalDetectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ElectrochemicalDetectionModeP,
			Description->"For each member of Standards, the mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardReferenceElectrodeMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ReferenceElectrodeModeP,
			Description->"For each member of Standards, the mode of operation of the reference electrode either to monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference).",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardVoltageProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], VoltageP}...}|VoltageP),
			Description->"For each member of Standards, the time-dependent voltage setting throughout the measurement.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardWaveformProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Minute],ObjectP[Object[Method,Waveform]]}...}|ObjectP[Object[Method,Waveform]],
			Description->"For each member of Standards, a series of time-dependent voltage setting (waveform) that will be repeated over the entire duration of the analysis.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardWaveformObjects->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Waveform],
			Description->"The waveform method objects used during the detection of Standards.",
			Category->"Standards"
		},
		StandardElectrochemicalSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0/Second],
			Units->1/Second,
			Description->"For each member of Standards, indicates the frequency of amperometric measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
			IndexMatching->Standards,
			Category->"Standards"
		},
		StandardDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"For each member of Standards, the temperature of the detection oven where the eletrochemical detection takes place.",
			IndexMatching->Standards,
			Category->"Standards"
		},

		(* --- Blanks --- *)
		Blanks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"Samples that are used as negative controls, typically run to calibrate background signal of the instrument and buffer.",
			Category->"Blanking"
		},
		BlankAnalysisChannels->{
			Format->Multiple,
			Class->Expression,
			Pattern:>AnalysisChannelP,
			Description->"For each member of Blanks, the flow path into which the blank is injected, either cation or anion channel.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		AnionBlanks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"Negative control samples that are injected into the anion channel of the instrument.",
			Category->"Blanking"
		},
		CationBlanks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"Negative control samples that are injected into the cation channel of the instrument.",
			Category->"Blanking"
		},
		AnionBlankSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of AnionBlanks, the physical quantity taken from the blank and injected onto the column.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		CationBlankSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of CationBlanks, the physical quantity taken from the blank and injected onto the column.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		BlankSampleVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro Liter],
			Units->Liter Micro,
			Description->"For each member of Blanks, the physical quantity taken from the blank and injected onto the column.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		AnionBlankColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionBlanks, the nominal temperature of the column compartment during a run for anion channel.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		CationBlankColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of CationBlanks, the nominal temperature of the column compartment during a run for cation channel.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		BlankColumnTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of Blanks, the nominal temperature of the column compartment during a run.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankEluentGradient->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Millimolar, 100 Millimolar]}...}|RangeP[0 Millimolar, 100 Millimolar]),
			Description->"For each member of AnionBlanks, the eluent concentration over time, in the form: {Time, eluent concentration in Millimolar} or a single eluent concentration for the entire run.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		AnionBlankFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of AnionBlanks, the total rate of mobile phase pumped through the instrument in anion channel.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		CationBlankGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of CationBlanks, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		CationBlankGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationBlanks, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		CationBlankGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of CationBlanks, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		CationBlankGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of CationBlanks, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		CationBlankFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of CationBlanks, the total rate of mobile phase pumped through the instrument in cation channel.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		BlankGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of Blanks, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of Blanks, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description->"For each member of Blanks, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each member of Blanks, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankFlowRate->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ListableP[{GreaterEqualP[0*Minute], GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0*Milli*Liter)/Minute],
			Description->"For each member of Blanks, the total rate of mobile phase pumped through the instrument.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		AnionBlankGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each member of AnionBlanks, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		CationBlankGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each member of CationBlanks, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		BlankGradientMethods->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Gradient],
			Description->"For each member of Blanks, the methods used during the course of the run consisting of buffer composition and time points.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		AnionBlankSuppressorMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each member of AnionBlanks, the operation method of the anion suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		AnionBlankSuppressorVoltage->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each member of AnionBlanks, the electrical potential difference applied to the Anion Suppressor.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		AnionBlankSuppressorCurrent->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each member of AnionBlanks, the rate of electric charge flow between the electrodes in the suppresor during the run for anion channel.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		CationBlankSuppressorMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each member of CationBlanks, the operation method of the cation suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		CationBlankSuppressorVoltage->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each member of CationBlanks, the electrical potential difference applied to the Cation Suppressor.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		CationBlankSuppressorCurrent->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each member of CationBlanks, the rate of electric charge flow between the electrodes in the suppresor during the run for cation channel.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		AnionBlankDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of AnionBlanks, the temperature of the cell where conductivity is measured for anion channel.",
			IndexMatching->AnionBlanks,
			Category->"Blanking"
		},
		CationBlankDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each member of CationBlanks, the temperature of the cell where conductivity is measured for cation channel.",
			IndexMatching->CationBlanks,
			Category->"Blanking"
		},
		BlanksStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP|Disposal,
			Description->"For each member of Blanks, the storage conditions under which the blank samples should be stored after the protocol is completed.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankAbsorbanceWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"For each member of Blanks, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankAbsorbanceSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units->1/Second,
			Description->"For each member of Blanks, indicates the frequency of measurement for UVVis at all specified wavelengths of light.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankElectrochemicalDetectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ElectrochemicalDetectionModeP,
			Description->"For each member of Blanks, the mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankReferenceElectrodeMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ReferenceElectrodeModeP,
			Description->"For each member of Blanks, the mode of operation of the reference electrode either to monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference).",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankVoltageProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], VoltageP}...}|VoltageP),
			Description->"For each member of Blanks, the time-dependent voltage setting throughout the measurement.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankWaveformProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Minute],ObjectP[Object[Method,Waveform]]}...}|ObjectP[Object[Method,Waveform]],
			Description->"For each member of Blanks, a series of time-dependent voltage setting (waveform) that will be repeated over the entire duration of the analysis.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankWaveformObjects->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Waveform],
			Description->"The waveform method objects used during the detection of Blanks.",
			Category->"Blanking"
		},
		BlankElectrochemicalSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0/Second],
			Units->1/Second,
			Description->"For each member of Blanks, indicates the frequency of amperometric measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		BlankDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"For each member of Blanks, the temperature of the detection oven where the eletrochemical detection takes place.",
			IndexMatching->Blanks,
			Category->"Blanking"
		},
		
		(*--- Final Buffer state ---*)
		FinalInletSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of deionized water in the reservoir immediately after the experiment was finished.",
			Category->"General"
		},
		FinalBufferAVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of Buffer A in the reservoir immediately after the experiment was finished.",
			Category->"General"
		},
		FinalBufferBVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of Buffer B in the reservoir immediately after the experiment was finished.",
			Category->"General"
		},
		FinalBufferCVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of Buffer C in the reservoir immediately after the experiment was finished.",
			Category->"General"
		},
		FinalBufferDVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of Buffer D in the reservoir immediately after the experiment was finished.",
			Category->"General"
		},
		FinalNeedleWashSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The volume of NeedleWashSolution in the reservoir immediately after the experiment was finished.",
			Category->"General"
		},
		FinalInletSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of deionized water in the reservoir taken immediately after the experiment was completed.",
			Category->"Gradient"
		},
		FinalBufferAAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of Buffer A taken immediately after the experiment was completed.",
			Category->"Gradient"
		},
		FinalBufferBAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of Buffer B taken immediately after the experiment was completed.",
			Category->"Gradient"
		},
		FinalBufferCAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of Buffer C taken immediately after the experiment was completed.",
			Category->"Gradient"
		},
		FinalBufferDAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of Buffer D taken immediately after the experiment was completed.",
			Category->"Gradient"
		},
		FinalNeedleWashSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of NeedleWashSolution taken immediately after the experiment was completed.",
			Category->"Gradient"
		},

		(* --- System Prime Information --- *)
		SystemPrimeEluentGeneratorInletSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent used to feed into the eluent generator in the flow path at the start of the protocol before column installation for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeBufferA->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent used to purge Buffer line A at the start of the protocol before column installation for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeBufferB->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent used to purge Buffer line B at the start of the protocol before column installation for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeBufferC->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent used to purge Buffer line C at the start of the protocol before column installation for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeBufferD->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent used to purge Buffer line D at the start of the protocol before column installation for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeBufferContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container]|Object[Sample]|Model[Sample],Null},
			Description->"A list of deck placements used for placing system prime buffers needed to run the prime protocol onto the instrument buffer deck.",
			Category->"Cleaning",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		InitialSystemPrimeInletSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of SystemPrimeEluentGeneratorInletSolution immediately before the priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferAVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of SystemPrimeBufferA immediately before the priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferBVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of SystemPrimeBufferB immediately before the priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferCVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of SystemPrimeBufferC immediately before the priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferDVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of SystemPrimeBufferD immediately before the priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeInletSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeInletSolution taken immediately before priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferAAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferA taken immediately before priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferBAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferB taken immediately before priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferCAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferC taken immediately before priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemPrimeBufferDAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferD taken immediately before priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemPrimeGradient->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"The method defining buffer composition over time used during the anion channel system prime, where only buffers are pumped through the system.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemPrimeGradient->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"The method defining buffer composition over time used during the cation channel system prime, where only buffers are pumped through the system.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeGradient->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Gradient],
			Description->"The method defining buffer composition over time used during the system prime, where only buffers are pumped through the system.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeInletSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemPrimeEluentGeneratorInletSolution immediately after the system prime.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferAVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemPrimeBufferA immediately after the system prime.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferBVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemPrimeBufferB immediately after the system prime.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferCVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemPrimeBufferC immediately after the system prime.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferDVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemPrimeBufferD immediately after the system prime.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeInletSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeEluentGeneratorInletSolution taken immediately after priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferAAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferA taken immediately after priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferBAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferB taken immediately after priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferCAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferC taken immediately after priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemPrimeBufferDAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemPrimeBufferD taken immediately after priming the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemPrimeWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the system prime imported onto the system for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemPrimeWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the system prime imported onto the system for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the system prime imported onto the system.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemPrimeImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for the system prime for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemPrimeImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for the system prime for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for the system prime.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemPrimeExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's system prime raw data to the server for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemPrimeExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's system prime raw data to the server for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's system prime raw data to the server.",
			Category->"Cleaning",
			Developer->True
		},
		SystemPrimeSequenceName->{ (*Can we get rid of this or refactor?*)
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The software sequence name for the protocol's system prime.",
			Category->"Cleaning",
			Developer->True
		},

		(* --- Column Prime Information --- *)
		ColumnPrimeEluentGradients->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Millimolar, 100 Millimolar]}...}|RangeP[0 Millimolar, 100 Millimolar]),
			Description->"For each anion column prime, the eluent concentration over time, in the form: {Time, eluent concentration in Millimolar} or a single eluent concentration for the entire run.",
			Category->"Column Prime"
		},
		AnionColumnPrimeGradients->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each anion column prime, the composition of the buffer within the flow, defined for specific time points during the equilibration of the Columns (column prime).",
			Category->"Column Prime"
		},
		CationColumnPrimeGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each cation column prime, the percentage of Buffer A in the composition over time, in the form: {Time, % Buffer A} or a single % BufferA for the entire run.",
			Category->"Column Prime"
		},
		CationColumnPrimeGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each cation column prime, the percentage of Buffer B in the composition over time, in the form: {Time, % Buffer B} or a single % BufferB for the entire run.",
			Category->"Column Prime"
		},
		CationColumnPrimeGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each cation column prime, the percentage of Buffer C in the composition over time, in the form: {Time, % Buffer C} or a single % BufferC for the entire run.",
			Category->"Column Prime"
		},
		CationColumnPrimeGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each cation column prime, the percentage of Buffer D in the composition over time, in the form: {Time, % Buffer D} or a single % BufferD for the entire run.",
			Category->"Column Prime"
		},
		CationColumnPrimeGradients->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,IonChromatographyGradient],
			Description->"For each cation column prime, the composition of the buffer within the flow, defined for specific time points during the equilibration of the Columns (column prime).",
			Category->"Column Prime"
		},
		ColumnPrimeGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column prime, the percentage of Buffer A in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category->"Column Prime"
		},
		ColumnPrimeGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column prime, the percentage of Buffer B in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category->"Column Prime"
		},
		ColumnPrimeGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column prime, the percentage of Buffer C in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			Category->"Column Prime"
		},
		ColumnPrimeGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column prime, the percentage of Buffer D in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			Category->"Column Prime"
		},
		ColumnPrimeGradients->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Gradient],
			Description->"For each column prime, the composition of the buffer within the flow, defined for specific time points during the equilibration of the Columns (column prime).",
			Category->"Column Prime"
		},
		AnionColumnPrimeTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the column compartment during a run for anion channel.",
			Category->"Column Prime"
		},
		CationColumnPrimeTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the column compartment during a run for cation channel.",
			Category->"Column Prime"
		},
		ColumnPrimeTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the column compartment during a run.",
			Category->"Column Prime"
		},
		AnionColumnPrimeSuppressorMode->{
			Format->Single,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each anion column prime, the operation method of the anion suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			Category->"Column Prime"
		},
		AnionColumnPrimeSuppressorVoltage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each anion column prime, the electrical potential difference applied to the Anion Suppressor.",
			Category->"Column Prime"
		},
		AnionColumnPrimeSuppressorCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each column prime, the rate of electric charge flow between the electrodes in the suppresor for anion channel.",
			Category->"Column Prime"
		},
		CationColumnPrimeSuppressorMode->{
			Format->Single,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each cation column prime, the operation method of the cation suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			Category->"Column Prime"
		},
		CationColumnPrimeSuppressorVoltage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each cation column prime, the electrical potential difference applied to the Cation Suppressor.",
			Category->"Column Prime"
		},
		CationColumnPrimeSuppressorCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each column prime, the rate of electric charge flow between the electrodes in the suppresor for cation channel.",
			Category->"Column Prime"
		},
		AnionColumnPrimeDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each column prime, the temperature of the cell where conductivity is measured for anion channel.",
			Category->"Column Prime"
		},
		CationColumnPrimeDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each column prime, the temperature of the cell where conductivity is measured for cation channel.",
			Category->"Column Prime"
		},
		ColumnPrimeAbsorbanceWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"For each member of ColumnPrime, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			Category->"Column Prime"
		},
		ColumnPrimeAbsorbanceSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units->1/Second,
			Description->"For each member of ColumnPrime, indicates the frequency of measurement for UVVis at all specified wavelengths of light.",
			Category->"Column Prime"
		},
		ColumnPrimeElectrochemicalDetectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ElectrochemicalDetectionModeP,
			Description->"For each member of ColumnPrime, the mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			Category->"Column Prime"
		},
		ColumnPrimeReferenceElectrodeMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ReferenceElectrodeModeP,
			Description->"For each member of ColumnPrime, a combination pH-Ag/AgCl reference electrode that can be used to either monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference).",
			Category->"Column Prime"
		},
		ColumnPrimeVoltageProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], VoltageP}...}|VoltageP),
			Description->"For each member of ColumnPrime, the time-dependent voltage setting throughout the measurement.",
			Category->"Column Prime"
		},
		ColumnPrimeWaveformProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Minute],ObjectP[Object[Method,Waveform]]}...}|ObjectP[Object[Method,Waveform]],
			Description->"For each member of ColumnPrime, a series of time-dependent voltage setting (waveform) that will be repeated over the entire duration of the analysis.",
			Category->"Column Prime"
		},
		ColumnPrimeWaveformObjects->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Waveform],
			Description->"The waveform method objects used during the detection of Blanks.",
			Category->"Column Prime"
		},
		ColumnPrimeElectrochemicalSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0/Second],
			Units->1/Second,
			Description->"For each member of ColumnPrime, indicates the frequency of amperometric measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
			Category->"Column Prime"
		},
		ColumnPrimeDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"For each member of ColumnPrime, the temperature of the detection oven where the eletrochemical detection takes place.",
			Category->"Column Prime"
		},


		(*--- Column Flush Information ---*)
		ColumnFlushEluentGradients->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Millimolar,100 Millimolar]}...}|RangeP[0 Millimolar, 100 Millimolar]),
			Description->"For each column flush, the eluent concentration over time, in the form: {Time, eluent concentration in Millimolar} or a single eluent concentration for the entire run.",
			Category->"Column Flush"
		},
		AnionColumnFlushGradients->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method],
			Description->"For each anion column flush (when solvent is run through without injection), the method used to describe the buffer composition over time.",
			Category->"Column Flush"
		},
		CationColumnFlushGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category->"Column Flush"
		},
		CationColumnFlushGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category->"Column Flush"
		},
		CationColumnFlushGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			Category->"Column Flush"
		},
		CationColumnFlushGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			Category->"Column Flush"
		},
		CationColumnFlushGradients->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method],
			Description->"For each cation column flush (when solvent is run through without injection), the method used to describe the buffer composition over time.",
			Category->"Column Flush"
		},
		ColumnFlushGradientA->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category->"Column Flush"
		},
		ColumnFlushGradientB->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category->"Column Flush"
		},
		ColumnFlushGradientC->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			Category->"Column Flush"
		},
		ColumnFlushGradientD->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent, 100 Percent]),
			Description->"For each column flush, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			Category->"Column Flush"
		},
		ColumnFlushGradients->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method],
			Description->"For each column flush (when solvent is run through without injection), the method used to describe the buffer composition over time.",
			Category->"Column Flush"
		},
		AnionColumnFlushTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the column compartment during anion column flush.",
			Category->"Column Flush"
		},
		CationColumnFlushTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the column compartment during cation column flush.",
			Category->"Column Flush"
		},
		ColumnFlushTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The nominal temperature of the column compartment during column flush.",
			Category->"Column Flush"
		},
		AnionColumnFlushSuppressorMode->{
			Format->Single,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each anion column flush, the operation method of the anion suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			Category->"Column Flush"
		},
		AnionColumnFlushSuppressorVoltage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each anion column flush, the electrical potential difference applied to the Anion Suppressor.",
			Category->"Column Flush"
		},
		AnionColumnFlushSuppressorCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each column flush, the rate of electric charge flow between the electrodes in the suppresor for anion channel.",
			Category->"Column Flush"
		},
		CationColumnFlushSuppressorMode->{
			Format->Single,
			Class->Expression,
			Pattern:>SuppressorModeP,
			Description->"For each cation column flush, the operation method of the cation suppressor. Under DynamidMode, constant voltage is supplied to the suppressor with variable current while under LegacyMode, constant current is supplied.",
			Category->"Column Flush"
		},
		CationColumnFlushSuppressorVoltage->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Volt],
			Units->Volt,
			Description->"For each cation column flush, the electrical potential difference applied to the Cation Suppressor.",
			Category->"Column Flush"
		},
		CationColumnFlushSuppressorCurrent->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli Ampere],
			Units->Milli Ampere,
			Description->"For each column flush, the rate of electric charge flow between the electrodes in the suppresor for cation channel.",
			Category->"Column Flush"
		},
		AnionColumnFlushDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each column flush, the temperature of the cell where conductivity is measured for anion channel.",
			Category->"Column Flush"
		},
		CationColumnFlushDetectionTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"For each column flush, the temperature of the cell where conductivity is measured for cation channel.",
			Category->"Column Flush"
		},
		ColumnFlushAbsorbanceWavelength->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*Nanometer],
			Units->Nanometer,
			Description->"For each member of ColumnFlush, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			Category->"Column Flush"
		},
		ColumnFlushAbsorbanceSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units->1/Second,
			Description->"For each member of ColumnFlush, indicates the frequency of measurement for UVVis at all specified wavelengths of light.",
			Category->"Column Flush"
		},
		ColumnFlushElectrochemicalDetectionMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ElectrochemicalDetectionModeP,
			Description->"For each member of ColumnFlush, the mode of operation for the electrochemical detector, including DC Amperometric Detection, Pulsed Amperometric Detection, and Integrated Pulsed Amperometric Detection. In DC Amperometric Detection, a constant voltage is applied. In contrast, Pulsed Amperometric Detections first apply a working potential followed by higher or lower potentials that are used for cleaning the electrode. Further, Integrated Amperometric Detection integrates current over a single potential whereas Integrated Pulsed Amperometric Detection integrates current over two or more potentials.",
			Category->"Column Flush"
		},
		ColumnFlushReferenceElectrodeMode->{
			Format->Multiple,
			Class->Expression,
			Pattern:>ReferenceElectrodeModeP,
			Description->"For each member of ColumnFlush, a combination pH-Ag/AgCl reference electrode that can be used to either monitor the buffer pH (\"pH\" reference) or to serve as a cell reference electrode with a constant potential (\"AgCl\" reference).",
			Category->"Column Flush"
		},
		ColumnFlushVoltageProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({{GreaterEqualP[0 Minute], VoltageP}...}|VoltageP),
			Description->"For each member of ColumnFlush, the time-dependent voltage setting throughout the measurement.",
			Category->"Column Flush"
		},
		ColumnFlushWaveformProfile->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Minute],ObjectP[Object[Method,Waveform]]}...}|ObjectP[Object[Method,Waveform]],
			Description->"For each member of ColumnFlush, a series of time-dependent voltage setting (waveform) that will be repeated over the entire duration of the analysis.",
			Category->"Column Flush"
		},
		ColumnFlushWaveformObjects->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method,Waveform],
			Description->"The waveform method objects used during the detection of Blanks.",
			Category->"Column Flush"
		},
		ColumnFlushElectrochemicalSamplingRate->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0/Second],
			Units->1/Second,
			Description->"For each member of ColumnFlush, indicates the frequency of amperometric measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
			Category->"Column Flush"
		},
		ColumnFlushDetectionTemperature->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Celsius],
			Units->Celsius,
			Description->"For each member of ColumnFlush, the temperature of the detection oven where the eletrochemical detection takes place.",
			Category->"Column Flush"
		},

		(*--- SystemFlush ---*)
		SystemFlushEluentGeneratorInletSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent pumped to the eluent generator in the flow path used to clean the instrument and lines after column removal for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushBufferA->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent through channel A used to clean the instrument and lines after column removal for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushBufferB->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent through channel B used to clean the instrument and lines after column removal for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushBufferC->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent through channel C used to clean the instrument and lines after column removal for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushBufferD->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample], Model[Sample]],
			Description->"The solvent through channel D used to clean the instrument and lines after column removal for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushBufferContainerPlacements->{
			Format->Multiple,
			Class->{Link,Expression},
			Pattern:>{_Link,{LocationPositionP..}},
			Relation->{Object[Container]|Object[Sample]|Model[Sample],Null},
			Description->"A list of deck placements used for placing system fush buffers needed to run the flush protocol onto the instrument buffer deck.",
			Category->"Cleaning",
			Developer->True,
			Headers->{"Object to Place","Placement Tree"}
		},
		InitialSystemFlushInletSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushEluentGeneratorInletSolution immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferAVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferA immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferBVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferB immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferCVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferC immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferDVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferD immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushInletSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of the SystemFlushInletSolution taken immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferAAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of the SystemFlushBufferA taken immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferBAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of the SystemFlushBufferB taken immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferCAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of the SystemFlushBufferC taken immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		InitialSystemFlushBufferDAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of the SystemFlushBufferD taken immediately before flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemFlushGradient->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method],
			Description->"The composition of solvents over time used to purge the instrument lines at the end of the experiment protocol for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemFlushGradient->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method],
			Description->"The composition of solvents over time used to purge the instrument lines at the end of the experiment protocol for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushGradient->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Method],
			Description->"The composition of solvents over time used to purge the instrument lines at the end of the experiment protocol.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushInletSolutionVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushEluentGeneratorInletSolution immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferAVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferA immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferBVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferB immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferCVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferC immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferDVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter,
			Description->"The physical quantity of the SystemFlushBufferD immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushInletSolutionAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemFlushEluentGeneratorInletSolution taken immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferAAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemFlushBufferA taken immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferBAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemFlushBufferB taken immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferCAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemFlushBufferC taken immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		FinalSystemFlushBufferDAppearance->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"An image of SystemFlushBufferD taken immediately after flushing the instrument.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemFlushWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the system flush imported onto the system for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemFlushWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the system flush imported onto the system for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushWorklistFilePath->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file describing the system flush imported onto the system.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemFlushImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for the system flush for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemFlushImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for the system flush for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushImportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that can be imported the protocol into the software for the system flush.",
			Category->"Cleaning",
			Developer->True
		},
		AnionSystemFlushExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's system flush raw data to the server for anion channel.",
			Category->"Cleaning",
			Developer->True
		},
		CationSystemFlushExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's system flush raw data to the server for cation channel.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's system flush raw data to the server.",
			Category->"Cleaning",
			Developer->True
		},
		SystemFlushSequenceName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The software sequence name for the protocol's system flush.",
			Category->"Cleaning",
			Developer->True
		},
		PurgeSequence->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The software queue used for purging in the case of an Instrument error.",
			Category->"Purging",
			Developer->True
		},

		(* --- Experimental Results --- *)
		AnionExportDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory to which data will be saved for anion channel.",
			Category->"Experimental Results",
			Developer->True
		},
		CationExportDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory to which data will be saved for cation channel.",
			Category->"Experimental Results",
			Developer->True
		},
		ExportDirectory->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The directory to which data will be saved.",
			Category->"Experimental Results",
			Developer->True
		},
		AnionExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's raw data to the server for anion channel.",
			Category->"Experimental Results",
			Developer->True
		},
		CationExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's raw data to the server for cation channel.",
			Category->"Experimental Results",
			Developer->True
		},
		ExportScriptLocation->{
			Format->Single,
			Class->String,
			Pattern:>FilePathP,
			Description->"The compiled file that exports the protocol's raw data to the server.",
			Category->"Experimental Results",
			Developer->True
		},
		AnionStandardData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The chromatography traces generated for the anion standard's injection.",
			Category->"Experimental Results"
		},
		CationStandardData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The chromatography traces generated for the cation standard's injection.",
			Category->"Experimental Results"
		},
		StandardData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The chromatography traces generated for the standard's injection.",
			Category->"Experimental Results"
		},
		AnionBlankData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The chromatography traces generated for the anion blank's injection.",
			Category->"Experimental Results"
		},
		CationBlankData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The chromatography traces generated for the cation blank's injection.",
			Category->"Experimental Results"
		},
		BlankData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The chromatography traces generated for the blank's injection.",
			Category->"Experimental Results"
		},
		AnionPrimeData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for any anion column prime runs.",
			Category->"Experimental Results"
		},
		CationPrimeData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for any cation column prime runs.",
			Category->"Experimental Results"
		},
		PrimeData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for any column prime runs.",
			Category->"Experimental Results"
		},
		AnionFlushData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for any anion column flush runs.",
			Category->"Experimental Results"
		},
		CationFlushData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for any cation column flush runs.",
			Category->"Experimental Results"
		},
		FlushData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for any column flush runs.",
			Category->"Experimental Results"
		},
		AnionSystemPrimeData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for the anion system prime run whereby the system is flushed with solvent before the column is connected.",
			Category->"Experimental Results",
			Developer->True
		},
		CationSystemPrimeData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for the cation system prime run whereby the system is flushed with solvent before the column is connected.",
			Category->"Experimental Results",
			Developer->True
		},
		SystemPrimeData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for the system prime run whereby the system is flushed with solvent before the column is connected.",
			Category->"Experimental Results",
			Developer->True
		},
		AnionSystemFlushData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for the anion system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category->"Experimental Results",
			Developer->True
		},
		CationSystemFlushData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for the cation system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category->"Experimental Results",
			Developer->True
		},
		SystemFlushData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"Chromatography traces generated for the system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category->"Experimental Results",
			Developer->True
		},
		InitialAnalyteVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter Micro,
			Description->"For each member of SamplesIn, the physical quantity of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) measured prior to injection.",
			IndexMatching->SamplesIn,
			Category->"Experimental Results"
		},
		InjectedAnalyteVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter Micro,
			Description->"For each member of SamplesIn, the physical quantity of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) calculated by subtracting FinalAnalytesVolumes from InitialAnalytesVolumes.",
			IndexMatching->SamplesIn,
			Category->"Experimental Results"
		},
		FinalAnalyteVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Liter],
			Units->Liter Micro,
			Description->"For each member of SamplesIn, the physical quantity of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) measured immediately after the experiment.",
			IndexMatching->SamplesIn,
			Category->"Experimental Results"
		},
		WasteWeightData->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The weight data of the waste carboy after the HPLC protocol is complete.",
			Category->"Experimental Results",
			Developer->True
		},
		AnionInitialPressureLowerLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The lower limit of the pressure before the run is aborted for anion channel.",
			Category->"General",
			Developer->True
		},
		AnionInitialPressureUpperLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The upper limit of the pressure before the run is aborted for anion channel.",
			Category->"General",
			Developer->True
		},
		CationInitialPressureLowerLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The lower limit of the pressure before the run is aborted for cation channel.",
			Category->"General",
			Developer->True
		},
		CationInitialPressureUpperLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The upper limit of the pressure before the run is aborted for cation channel.",
			Category->"General",
			Developer->True
		},
		InitialPressureLowerLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The lower limit of the pressure before the run is aborted.",
			Category->"General",
			Developer->True
		},
		InitialPressureUpperLimit->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*PSI],
			Units->PSI,
			Description->"The upper limit of the pressure before the run is aborted.",
			Category->"General",
			Developer->True
		}
	}
}];
