(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, MicrowaveDigestion], {
  Description -> "A protocol for performing microwave digestion, in which samples are chemically digested and solubilized using caustic/oxidizing reagents and microwave radiation.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {

    (* ------------------------- *)
    (* -------- General -------- *)
    (* ------------------------- *)

    Instrument -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Model[Instrument],
        Object[Instrument]
      ],
      Description -> "The microwave reactor used for the MicrowaveDigestion protocol.",
      Category -> "General"
    },
    StirBar -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Part,StirBar],
        Model[Part, StirBar]
      ],
      Description -> "The magnetic stirbars used to mix the reaction vessel during heating.",
      Category -> "General"
    },
    DigestionAgentGlassware -> {
      Format -> Multiple,
      Class -> {Link, Link},
      Pattern :> {_Link, _Link},
      Relation -> {
        Alternatives[
          Object[Container, ReactionVessel],
          Model[Container, ReactionVessel]
        ],
        Alternatives[
          Object[Container,GraduatedCylinder],
          Model[Container, GraduatedCylinder]
        ]
      },
      Headers -> {"Reaction Vessel", "Glassware"},
      Description -> "The glassware required to perform digestion agent transfers.",
      Category -> "General",
      Developer -> True
    },
    ReactionVessels -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container,ReactionVessel, Microwave],
        Model[Container, ReactionVessel, Microwave]
      ],
      Description -> "For each member of SamplesIn, the vessel in which the digestion is performed.",
      Category -> "General",
      IndexMatching -> SamplesIn
    },
    ReactionVesselCaps -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,Cap],
        Model[Item, Cap]
      ],
      Description -> "The caps for the vessel in which the digestion is performed.",
      Category -> "General"
    },
    Tweezers -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Item,Tweezer],
        Model[Item, Tweezer]
      ],
      Description -> "The tweezers used to transfer tablets during sample preparation.",
      Category -> "General"
    },
    SampleTypes -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> Alternatives[Tablet, Organic, Inorganic],
      Description -> "For each member of SamplesIn, the type of material being digested.",
      Category -> "General",
      IndexMatching ->SamplesIn
    },
    SampleAmounts -> {
      Format ->Multiple,
      Class -> VariableUnit,
      Pattern:> Alternatives[GreaterP[0 Microliter], GreaterP[0 Milligram], GreaterP[0]],
      Units -> None,
      Description -> "For each member of SamplesIn, the amount of material digested.",
      Category -> "General",
      IndexMatching -> SamplesIn
    },
    (* this needs to be updated to be a real placements field with the form {source container, destination container, destination position} *)
    ReactionVesselPlacements -> {
      Format -> Multiple,
      Class -> {Link,Link,Expression},
      Pattern :> {_Link,_Link,LocationPositionP},
      Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Instrument]|Model[Container]|Model[Instrument]),Null},
      Description -> "The positions in which the reaction vessels will be placed on the instrument.",
      Category -> "General",
      Headers -> {"Object to Place","Destination Object","Destination Position"},
      Developer ->True
    },
    Rack ->{
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> (Object[Container, Rack]|Model[Container, Rack]),
      Description -> "The racks used to hold the reaction vessels during loading and transportation.",
      Category -> "General",
      Developer ->True
    },


    (* ----------------- *)
    (* -- SAMPLE PREP -- *)
    (* ----------------- *)

    CrushSamples -> {
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, indicates if the sample is a tablet that will be crushed prior to digestion.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    PreDigestionMixParameters -> {
      Format -> Multiple,
      Class -> {Expression, Expression},
      Pattern:>{GreaterP[0 Second], Alternatives[Low, Medium, High, Off]},
      Headers -> {"Mix Time","Mix Rate"},
      Description -> "For each member of SamplesIn, the amount of time and mix rate used while mixing the reaction vessel prior to heating.",
      Category -> "Sample Preparation",
      IndexMatching -> SamplesIn
    },
    LoadReactionVesselPrimitives->{
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP|SamplePreparationP,
      Description -> "A set of instructions specifying the loading of the reaction vessel with the sample.",
      Category -> "Sample Preparation"
    },
    LoadReactionVesselManipulation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,SampleManipulation]|Object[Protocol,ManualSamplePreparation],
      Description->"A sample manipulation protocol used to load the sample into the reaction vessel.",
      Category -> "Sample Preparation"
    },


    (* --------------- *)
    (* -- DIGESTION -- *)
    (* --------------- *)

    (*intentionally not index matched*)
    DigestionAgents -> {
      Format -> Multiple,
      Class -> {Link, Link, Link, Real},
      Pattern :> {_Link, _Link, _Link, GreaterP[0 Milliliter]},
      Units -> {None, None, None, Milliliter},
      Relation -> {
        Alternatives[Object[Sample], Model[Sample]],
        Alternatives[Object[Container], Model[Container]],
        Alternatives[Object[Sample], Model[Sample]],
        Null
      },
      Description -> "The volume and identity of the digestion agents used to digest and dissolve the SamplesIn.",
      Headers-> {"SampleIn", "Reaction Vessel", "Digestion Agent", "Amount"},
      Category -> "Digestion"
    },
    DigestionReady ->{
      Format -> Multiple,
      Class -> Expression,
      Pattern :> BooleanP,
      Description -> "For each member of SamplesIn, indicates if the sample does not require additional DigestionAgents.",
      Category -> "Digestion",
      IndexMatching -> SamplesIn
    },
    DigestionProfiles -> {
      Format -> Multiple,
      Class -> {Link, Real, Real, Expression},
      Pattern:> {_Link, GreaterEqualP[0 Minute], GreaterP[-80 Celsius], Alternatives[Off, Low, Medium, High]},
      Units -> {None, Minute, Celsius, None},
      Relation -> {Alternatives[Object[Sample],Model[Sample]], Null, Null, Null},
      Description -> "The heating and mixing profile that will be applied to the reaction vessel.",
      Headers -> {"Sample", "Time point","Temperature","Mixing Rate"},
      Category -> "Digestion"
    },
    DigestionMaxPower -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[1 Watt],
      Units -> Watt,
      Description -> "For each member of SamplesIn, the maximum microwave radiation power output used to heat the reaction vessel.",
      Category -> "Digestion",
      IndexMatching -> SamplesIn
    },
    DigestionMaxPressures -> {
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterP[1 PSI],
      Units -> PSI,
      Description -> "For each member of SamplesIn, the pressure at which the reactor will cease to heat the reaction vessel.",
      Category -> "Digestion",
      IndexMatching -> SamplesIn
    },


    (* ------------- *)
    (* -- VENTING -- *)
    (* ------------- *)

    (*intentionally not index matched*)
    PressureVentingParameters -> {
      Format -> Multiple,
      Class -> {Link, Real, Integer},
      Pattern :> {_Link, GreaterEqualP[1 PSI], GreaterEqualP[1]},
      Units -> {None, PSI, None},
      Relation -> {Alternatives[Object[Sample], Model[Sample]], Null, Null},
      Description -> "The pressure at which venting will occur and maximum number of attempted ventings used to regulate reaction vessel pressure during digestion.",
      Headers-> {"Sample", "Pressure Setpoint", "Number of Attempted Ventings"},
      Category -> "Digestion"
    },
    TargetPressureReduction -> {
      Format -> Multiple,
      Class -> Real,
      Pattern:> GreaterEqualP[1 PSI],
      Units -> PSI,
      Description -> "For each member of SamplesIn, the desired reduction in pressure during sample venting.",
      Category -> "Digestion",
      IndexMatching -> SamplesIn
    },


    (* ------------ *)
    (* -- WORKUP -- *)
    (* ------------ *)

    OutputAliquots -> {
      Format -> Multiple,
      Class -> {Real, Expression},
      Pattern :> {GreaterP[0 Milliliter], BooleanP},
      Units -> {Milliliter, None},
      Description -> "For each member of SamplesIn, the amount of sample that is aliquotted out of the reaction mixture when the digestion is complete.",
      Headers -> {"Aliquot Amount", "All"},
      Category -> "Workup",
      IndexMatching -> SamplesIn
    },
    OutputAliquotDilutions -> {
      Format -> Multiple,
      Class -> {Link, Real, Real},
      Pattern :> {_Link, GreaterP[0 Milliliter], GreaterP[0 Milliliter]},
      Relation -> {Alternatives[Object[Sample], Model[Sample]], Null, Null},
      Units -> {None, Milliliter, Milliliter},
      Headers ->{"Diluent","Diluent Volume", "Target Dilution Volume"},
      Description -> "For each member of SamplesIn, the identity and volume of the diluent into which the OutputAliquots are added to generate the output of this experiment.",
      Category -> "Workup",
      IndexMatching -> SamplesIn
    },
    PrepareOutputPrimitives->{
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP|SamplePreparationP,
      Description -> "A set of instructions specifying the transfer and dilution of samples from the reaction vessel to the ContainersOut.",
      Category -> "Sample Preparation"
    },
    PrepareOutputManipulation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,SampleManipulation]|Object[Protocol,ManualSamplePreparation],
      Description->"A sample manipulation protocol used to transfer and dilute samples from the reaction vessel to the ContainersOut.",
      Category -> "Sample Preparation"
    },
    WorkSurface -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Model[Instrument], Object[Instrument]],
      Description -> "The location in which all sample manipulations are performed.",
      Category -> "Sample Preparation",
      Developer -> True
    },
    StirBarRetriever -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Part, StirBarRetriever],
        Model[Part, StirBarRetriever]
      ],
      Description -> "The magnet and handle used to remove the StirBar from the reaction vessels.",
      Category -> "Sample Preparation",
      Developer -> True
    },

    (* -- Neutralization/NewFields -- *)
    WasteNeutralizationSolution -> {
      Format -> Single,
      Class -> Link,
      Pattern :> Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution used to neutralize waste generated in this experiment.",
      Category -> "Workup",
      Developer -> True
    },
    WasteNeutralizationDiluent -> {
      Format -> Single,
      Class -> Link,
      Pattern :> Link,
      Relation -> Alternatives[Object[Sample], Model[Sample]],
      Description -> "The solution used to dilute waste generated in this experiment prior to neutralization.",
      Category -> "Workup",
      Developer -> True
    },
    WasteNeutralizationContainer -> {
      Format -> Single,
      Class -> Link,
      Pattern :> Link,
      Relation -> Alternatives[Object[Container], Model[Container]],
      Description -> "The container used to dilute and neutralize waste generated in this experiment.",
      Category -> "Workup",
      Developer -> True
    },


    (* ----------------------- *)
    (* -- METHOD/DATA FILES -- *)
    (* ----------------------- *)


    DataFilePaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "For each member of SamplesIn, the file paths where the pressure and temperature traces are located.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer -> True
    },
    MethodFilePaths -> {
      Format -> Multiple,
      Class -> String,
      Pattern :> FilePathP,
      Description -> "The file path where the database used to run the SynergyD software is located.",
      Category -> "General",
      Developer -> True
    },
    DigestionRunTimes ->{
      Format -> Multiple,
      Class -> Real,
      Pattern :> GreaterEqualP[0 Minute],
      Units -> Minute,
      Description -> "For each member of SamplesIn, an estimate of how long the digestion will take to execute.",
      Category -> "General",
      IndexMatching -> SamplesIn,
      Developer ->True
    },


    (* ---------- *)
    (* -- DATA -- *)
    (* ---------- *)

    FileName->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The string name given to the instrument methods directory and the data output.",
      Category->"Experimental Results",
      Developer ->True
    },
    ReactionTemperature->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation -> Object[Data][Protocol],
      Description->"For each member of SamplesIn, the internal temperature of the reaction as measured by the IR sensor over the course of the digestion.",
      Category->"Experimental Results",
      IndexMatching -> SamplesIn
    },
    ReactionPressure->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation -> Object[Data][Protocol],
      Description->"For each member of SamplesIn, the internal pressure of the vessel over the course of the digestion.",
      Category->"Experimental Results",
      IndexMatching -> SamplesIn
    },
    PostDigestionImage->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation -> Object[EmeraldCloudFile],
      Description->"For each member of SamplesIn, an image of the reaction vessel directly after completing the digestion, prior to any aliquotting or dilution.",
      Category->"Experimental Results",
      IndexMatching -> SamplesIn
    },
    (* NOTE: These are all resource picked at once so that we can minimize trips to the VLM. *)
    RequiredObjects -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[
        Object[Container],
        Model[Container],
        Object[Sample],
        Model[Sample],
        Model[Item],
        Object[Item],
        Model[Part],
        Object[Part],
        Model[Plumbing],
        Object[Plumbing]
      ],
      Description -> "Objects required for the protocol.",
      Category -> "General",
      Developer -> True
    },
    (* NOTE: These are resource picked on the fly, but we need this field so that ReadyCheck knows if we can start the protocol or not. *)
    RequiredInstruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Instrument] | Object[Instrument],
      Description -> "Instruments required for the protocol.",
      Category -> "General",
      Developer -> True
    }
  }
}];

