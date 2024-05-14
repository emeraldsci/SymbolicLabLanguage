(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data,FragmentAnalysis],{
	Description->"Analytical data collected by the Fragment Analysis experiment. Raw data represents relative fluorescence units (RFU) vs migration time (from the sample inlet end to the capillary detection window) for each well containing a sample, ladder or blank.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* Method Information *)
		CapillaryArray->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,CapillaryArray],
			Description->"The ordered bundle of extremely thin, hollow tubes (capillary array) that is used by the instrument for analyte separation. Samples, Ladder(s) and Blank(s) run through the capillaries from the sample inlet end to the outlet end towards the reservoir during the separation step.",
			Category -> "Method Information"
		},
		SampleType->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[Sample,Ladder,Blank],
			Description->"Indicates whether the data represent a ladder, a blank, or a sample for analysis.",
			Category -> "Method Information"
		},
		Well->{
			Format->Single,
			Class->Expression,
			Pattern:>WellP,
			Description->"The well in the plate which the data is collected from.",
			Category -> "Method Information"
		},
		Ladders->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data, FragmentAnalysis],
			Description->"Ladder data acquired under the same experimental conditions to this data.",
			Category->"Method Information"
		},
		SeparationGel->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"The gel reagent that serves as sieving matrix to facilitate the optimal separation of the analyte fragments in each sample by size.",
			Category -> "Method Information"
		},
		Dye->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"The solution of a dye molecule that fluoresces when bound to DNA or RNA fragments in the sample and is used in the detection of the analyte fragments as it passes through the detection window of the capillary.",
			Category -> "Method Information"
		},
		SampleVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"The volume of the sample contained in the well of the plate prior to addition of SampleDiluent,SampleLoadingBuffer (if applicable). If PreparedPlate is True, this defaults to Null.",
			Category -> "Method Information"
		},
		LadderVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"The volume of the ladder contained in the well of the plate prior to addition of LadderLoadingBuffer (if applicable). If PreparedPlate is True, this defaults to Null.",
			Category -> "Method Information"
		},
		LoadingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"The solution added to the sample (after aliquoting, if applicable) or Ladder, to either add markers to (Quantitative) or further dilute (Qualitative) the sample or ladder prior to mixing (if applicable) and loading into the instrument.",
			Category -> "Method Information"
		},
		LoadingBufferVolume->{
			Format->Single,
			Class->Real,
			Units->Microliter,
			Pattern:>GreaterEqualP[0*Microliter],
			Description->"The volume of LoadingBuffer added to the sample (after aliquoting, if applicable) or Ladder, to either add markers to (Quantitative) or further dilute (Qualitative) the sample or ladder prior to loading into the instrument.",
			Category -> "Method Information"
		},
		Marker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[Sample],
			Description -> "The solution that contains upper and/or lower marker that elutes at a time corresponding to a known nucleotide size.",
			Category -> "Method Information"
		},
		MarkerInjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units->Second,
			Description -> "The duration an electric potential is applied across the capillaries to drive the markers into the capillaries. While a short InjectionTime is ideal since this in effect results in a small sample zone and reduces band broadening, a longer InjectionTime can serve to minimize voltage or pressure variability during injection.",
			Category -> "Method Information"
		},
		MarkerInjectionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilovolt],
			Units->Kilovolt,
			Description -> "The electric potential applied across the capillaries to drive the markers forward into the capillaries, from the MarkerPlate to the capillary inlet, during the MarkerInjection step.",
			Category -> "Method Information"
		},
		SampleInjectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units->Second,
			Description -> "The duration a electric potential (VoltageInjection) or pressure (PressureInjection) is applied across the capillaries to drive the samples into the capillaries.",
			Category -> "Method Information"
		},
		SampleInjectionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units->Kilovolt,
			Description -> "The electric potential applied across the capillaries to drive the samples or ladders forward into the capillaries, from the Sample Plate to the capillary inlet, during the SampleInjection step when the selected SampleInjectionTechnique is VoltageInjection.",
			Category -> "Method Information"
		},
		RunningBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"The buffer solution that contains ions that help conduct current through the gel in the capillaries and facilitates the separation of analyte fragments. The capillary is dipped in this solution during the capillary flush (if applicable) and separation runs.",
			Category -> "Method Information"
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units->Minute,
			Description -> "The duration for which the SeparationVoltage is applied across the capillaries in order for migration of analytes to occur.",
			Category -> "Method Information"
		},
		SeparationVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units->Kilovolt,
			Description -> "The electric potential applied across the capillaries as the sample analytes migrate through the capillaries during the sample run.",
			Category -> "Method Information"
		},
		(* Experimental Results *)
		Electropherogram -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Second,RFU}],
			Units -> {Second, RFU},
			Description -> "Time versus relative fluorescence unit (RFU) (electropherogram) representing the fluorescence detected by the charge-coupled device through the capillary array window at time points during the separation run of a sample. The peaks in the digital electropherogram represents the DNA or RNA fragment content(s) of the sample, where each peak area is proportional to the analyte fragment concentration, while the time indicates when the fragment passes through the capillary array window.",
			Category -> "Experimental Results"
		},
		ElectropherogramImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image file summary of the time versus relative fluorescence unit (RFU), processed peaks with indicated nucleotide size(s), and the consolidated fluorescence image detected through the capillary array detection window over time during the run of the sample.",
			Category -> "Experimental Results"
		},
		SimulatedGelImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image file that shows the consolidated fluorescence of all capillary arrays in a single experiment run detected through the capillary array detection window over time during the sample run.",
			Category -> "Experimental Results"
		},
		RawDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The main *.raw data file containing the results obtained from the experiment.",
			Category -> "Experimental Results"
		},
		(* Data Processing *)
		DNAFragmentSizeAnalyses->{
			Format->Single,
			Class->QuantityArray,
			Pattern:> QuantityCoordinatesP[{BasePair,RFU}],
			Units->{BasePair,RFU},
			Description->"The electropherogram of size (in base pairs) vs RFU as processed by the ProSize Software (new analysis function - AnalyzeFragmentSize).",
			Category->"Experimental Results"
		},
		RNAFragmentSizeAnalyses->{
			Format->Single,
			Class->QuantityArray,
			Pattern:> QuantityCoordinatesP[{Nucleotide,RFU}],
			Units->{Nucleotide,RFU},
			Description->"The electropherogram of size (in nucleotide) vs RFU as processed by the ProSize Software (new analysis function - AnalyzeFragmentSize).",
			Category->"Experimental Results"
		},
		DNAPeakTable->{
			Format->Single,
			Class->QuantityArray,
			Pattern:> QuantityCoordinatesP[{BasePair,Nanogram/Microliter}],
			Units->{BasePair,Nanogram/Microliter},
			Description->"The table of identified DNA peak size(s) and corresponding peak concentration(s) as processed by the ProSize Software assuming the suggested values of the AnalysisMethod for SampleVolume,SampleLoadingBuffer,SampleLoadingBufferVolume,LadderVolume,LadderLoadingBuffer and LadderLoadingVolume are used.",
			Category->"Experimental Results"
		},
		RNAPeakTable->{
			Format->Single,
			Class->QuantityArray,
			Pattern:> QuantityCoordinatesP[{Nucleotide,Nanogram/Microliter}],
			Units->{Nucleotide,Nanogram/Microliter},
			Description->"The table of identified RNA peak size(s) and corresponding peak concentration(s) as processed by the ProSize Software assuming the suggested values of the AnalysisMethod for SampleVolume,SampleLoadingBuffer,SampleLoadingBufferVolume,LadderVolume,LadderLoadingBuffer and LadderLoadingVolume are used.",
			Category->"Experimental Results"
		},
		FragmentSizeAnalysesImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image file summary of the electropherogram of nucleotide size versus RFU and the consolidated fluorescence detected through the capillary array detection window over time during the run of the sample.",
			Category -> "Experimental Results"
		},
		SampleQualityNumber->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,10],
			Description -> "The DNA Quality Number(DQN) for DNA samples OR RNA Quality Number(RQN) for RNA samples of the sample. DQN or RQN is a number between 0 to 10 that is determined by the Instrument software from the electropherogram which indicates the sample quality, where a higher number indicates higher sample percentage lies above the DNASizeThreshold.",
			Category -> "Experimental Results"
		},
		DNASizeThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*BasePair],
			Units->BasePair,
			Description -> "The number of base pairs that is used to calculate the SampleQualityNumber of a DNA sample depending on how much sample exceeds this threshold. The DQN is composed of the percentage of DNA above the threshold value divided by 10. This value is set by the appropriate global configuration(s) of the ProSize software.",
			Category -> "Data Processing"
		},
		DNATotalConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanogram/Microliter],
			Units->Nanogram/Microliter,
			Description -> "The total concetration of input DNA sample prior to addition of LoadingBuffer as determined by ProSize Software assuming the suggested values of the AnalysisMethod for SampleVolume,SampleLoadingBuffer,SampleLoadingBufferVolume,LadderVolume,LadderLoadingBuffer and LadderLoadingVolume are used.",
			Category -> "Experimental Results"
		},
		RNATotalConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanogram/Microliter],
			Units->Nanogram/Microliter,
			Description -> "The total concetration of input RNA sample prior to addition of LoadingBuffer as determined by ProSize Software assuming the suggested values of the AnalysisMethod for SampleVolume,SampleLoadingBuffer,SampleLoadingBufferVolume,LadderVolume,LadderLoadingBuffer and LadderLoadingVolume are used.",
			Category -> "Experimental Results"
		}
	}
}];
