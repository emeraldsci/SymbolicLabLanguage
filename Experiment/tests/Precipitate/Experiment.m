(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentExtractRNA: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentExtractRNA*)

DefineTests[ExperimentPrecipitate,
  {
    (* Additional examples *)

    (* Options *)
    (* Test PrecipitationReagent resolution *)
    Example[{Options,PrecipitationReagent,"PrecipitationReagent option is set to Model[Sample, StockSolution, \"id:AEqRl954GJb6\"] if Targetphase -> Liquid, or otherwise is set to Model[Sample, \"id:jLq9jXY4k6da\"]:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Liquid,Solid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationReagent -> {Model[Sample,StockSolution,"id:AEqRl954GJb6"],Model[Sample,"id:jLq9jXY4k6da"]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationReagentVolume resolution *)
    Example[{Options,PrecipitationReagentVolume,"PrecipitationReagentVolume option is set to the lesser of Lookup[samplePacket,Volume]/2 and Lookup[sampleContainerModelPacket,MaxVolume:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationReagentVolume -> EqualP[Quantity[0.125,"Milliliters"]]
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixType resolution *)
    Example[{Options,PrecipitationMixType,"PrecipitationMixType option is set to Pipette if PrecipitationMixVolume or NumberOfPrecipitationMixeslesser are set, otherwise PrecipitationMixType is set to Shake:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixVolume -> {100 Microliter,Automatic,Automatic},
        NumberOfPrecipitationMixes -> {Automatic,10,Automatic},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationMixType -> {Pipette,Pipette,Shake}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixRate resolution *)
    Example[{Options,PrecipitationMixRate,"PrecipitationMixRate option is set to 300 RPM if PrecipitationMixType is set to Shake, Otherwise PrecipitationMixRate is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationMixRate -> {Quantity[300,("Revolutions") / ("Minutes")],Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixTemperature resolution *)
    Example[{Options,PrecipitationMixTemperature,"PrecipitationMixTemperature option is set to Ambient if PrecipitationMixType is set to Shake, Otherwise PrecipitationMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationMixTemperature -> {Ambient,Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixTime resolution *)
    Example[{Options,PrecipitationMixTime,"PrecipitationMixTime option is set to 15 Minute if PrecipitationMixType is set to Shake, Otherwise PrecipitationMixTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationMixTime -> {Quantity[15,"Minutes"],Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixInstrument STAR resolution *)
    Example[{Options,PrecipitationMixInstrument,"PrecipitationMixInstrument option is set based for STAR workcell on PrecipitationMixType, PrecipitationMixTemperature, SeparationTechnique, and PrecipitationMixRate:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None,Shake},
        PrecipitationMixTemperature -> {Automatic,Automatic,Automatic,65 Celsius},(* TODO add for biostar*)
        SeparationTechnique -> {Pellet,Pellet,Pellet,Pellet},
        PrecipitationMixRate -> {Automatic,Automatic,Automatic,Automatic},
        NumberOfWashes -> 1,
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationMixInstrument -> {ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]],Null,Null,ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixInstrument bioSTAR resolution *)
    Example[{Options,PrecipitationMixInstrument,"PrecipitationMixInstrument option is set based for bioSTAR workcell on PrecipitationMixType, PrecipitationMixTemperature, SeparationTechnique, and PrecipitationMixRate:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None,Shake,Shake},PrecipitationMixTemperature -> {Automatic,Automatic,Automatic,65 Celsius,72 Celsius},WorkCell -> bioSTAR,
        PrecipitationMixRate -> {Automatic,Automatic,Automatic,300 RPM,500 RPM},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
      KeyValuePattern[
        {
          PrecipitationMixInstrument -> {ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]],Null,Null,ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]],ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test NumberOfPrecipitationMixes resolution *)
    Example[{Options,NumberOfPrecipitationMixes,"NumberOfPrecipitationMixes option is set to 10 if PrecipitationMixType is set to Pippete, Otherwise PrecipitationMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          NumberOfPrecipitationMixes -> {Null,10,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixVolume resolution *)
    Example[{Options,PrecipitationMixVolume,"PrecipitationMixVolume option is set properly based on sample size if PrecipitationMixType is set to Pippete, Otherwise PrecipitationMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationMixVolume -> {Null,EqualP[Quantity[0.188,Milliliter]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationTemperature resolution *)
    Example[{Options,PrecipitationTemperature,"PrecipitationTemperature option is set Ambient if PrecipitationTime is set to greater than 0 Minute, Otherwise PrecipitationTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationTime -> {Null,0 Minute,1 Minute},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationTemperature -> {Null,Null,Ambient}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationInstrument resolution *)
    Example[{Options,PrecipitationInstrument,"PrecipitationInstrument option is set properly based on PrecipitationTemperature and SeparationTechnique or is set to Null if PrecipitationTime is not greater than 0 Minute:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationTime -> {Null,0 Minute,15 Minute,15 Minute},
        PrecipitationTemperature -> {Automatic,Automatic,26 Celsius,Automatic},
        WorkCell -> STAR,(*Todo add the 71 Celsius back when adding BioStar tests*)
        SeparationTechnique -> {Pellet,Pellet,Filter,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitationInstrument -> {Null,Null,ObjectP[Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]],ObjectP[Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test FiltrationTechnique resolution *)
    Example[{Options,FiltrationTechnique,"FiltrationTechnique option is set to AirPressure if SeparationTechnique is set to Filter, Otherwise FiltrationTechnique is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Pellet,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          FiltrationTechnique -> {Null,AirPressure}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test FiltrationInstrument STAR resolution *)
    Example[{Options, {FiltrationInstrument, FilterCentrifugeIntensity}, "Filter options are set properly based on FiltrationTechnique in STAR WorkCell, otherwise FiltrationInstrument is set to Null:"},
      ExperimentPrecipitate[
        {
          Object[Sample, "DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        SampleVolume -> {100 Microliter, 250 Microliter, 250 Microliter},
        SeparationTechnique -> {Filter, Filter, Pellet},
        FiltrationTechnique -> {Centrifuge, AirPressure, Null},
        WorkCell -> STAR,
        Output -> Options
      ],
      KeyValuePattern[
        {
          FiltrationInstrument -> {ObjectP[Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]], ObjectP[Model[Instrument, PressureManifold, "id:J8AY5jD1okLb"]], Null},
          FilterCentrifugeIntensity -> {EqualP[2800 RPM], Null, Null}
        }
      ],
      TimeConstraint -> 3200
    ],

    (* Test FiltrationInstrument bioSTAR resolution *)
    Example[{Options, {FiltrationInstrument, FilterCentrifugeIntensity}, "Filter options are set properly based on FiltrationTechnique in bioSTAR WorkCell, otherwise FiltrationInstrument is set to Null:"},
      ExperimentPrecipitate[
        {
          Object[Sample, "DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        SampleVolume -> {200 Microliter, 250 Microliter, 250 Microliter},
        SeparationTechnique -> {Filter, Filter, Pellet},
        FiltrationTechnique -> {Centrifuge, AirPressure, Null},
        Sterile -> True,
        WorkCell -> bioSTAR,
        UnprecipitatedSampleContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate, Sterile"],
        Output -> Options
      ],
      KeyValuePattern[
        {
          FiltrationInstrument -> {ObjectP[Model[Instrument , Centrifuge, "id:kEJ9mqaVPAXe"]], ObjectP[Model[Instrument, PressureManifold, "id:4pO6dMOqXNpX"]], Null},
          FilterCentrifugeIntensity -> {EqualP[3600 GravitationalAcceleration], Null, Null}
        }
      ],
      TimeConstraint -> 3200
    ],

    (* Test FiltrationPressure resolution *)
    Example[{Options, {FiltrationPressure, FiltrationTime}, "FiltrationPressure is set to 40 PSI if FiltrationTechnique is set to AirPressure and and FiltrationTime is set 10 Minute if SeparationTechnique is set to Filter, otherwise set to Null:"},
      ExperimentPrecipitate[
        {
          Object[Sample, "DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        SampleVolume -> {250 Microliter, 100 Microliter, 250 Microliter},
        SeparationTechnique -> {Filter, Filter, Pellet},
        FiltrationTechnique -> {AirPressure, Centrifuge, Null},
        Output -> Options
      ],
      KeyValuePattern[
        {
          FiltrationPressure -> {EqualP[40 PSI], Null, Null},
          FiltrationTime -> {10 Minute, 10 Minute, Null}
        }
      ],
      TimeConstraint -> 3200
    ],

    (* Test FiltrateVolume resolution *)
    Example[{Options,FiltrateVolume,"FiltrateVolume option is set to sample volume plus PrecipitationReagentVolume if SeparationTechnique is set to Filter, otherwise FiltrateVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationReagentVolume -> {0.5 Milliliter,Automatic,Automatic},
        SeparationTechnique -> {Filter,Filter,Pellet},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          FiltrateVolume -> {EqualP[Quantity[0.75,"Milliliters"]],EqualP[Quantity[0.375,"Milliliters"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PelletVolume resolution *)
    Example[{Options,PelletVolume,"PelletVolume option is set to 1 MicroLiter if SeparationTechnique is set to Pellet, otherwise PelletVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Pellet,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PelletVolume -> {EqualP[1 Microliter],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PelletCentrifuge STAR resolution *)
    Example[{Options,PelletCentrifuge,"PelletCentrifuge option is set properly based on SeparationTechniqueTechnique:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Filter,Filter,Pellet},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PelletCentrifuge -> {Null,Null,ObjectP[Model[Instrument,Centrifuge,"id:vXl9j57YaYrk"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PelletCentrifuge bioSTAR resolution *)
    Example[{Options,PelletCentrifuge,"PelletCentrifuge option is set properly based on SeparationTechniqueTechnique:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Filter,Filter,Pellet},
        WorkCell -> bioSTAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
      KeyValuePattern[
        {
          PelletCentrifuge -> {Null,Null,ObjectP[Model[Instrument,Centrifuge,"id:kEJ9mqaVPAXe"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PelletCentrifugeIntensity STAR resolution *)
    Example[{Options,PelletCentrifugeIntensity,"PelletCentrifugeIntensity option is set to 4000g if SeparationTechnique is set to Pellet, otherwise FilterCentrifugeIntensity is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Filter,Filter,Pellet},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PelletCentrifugeIntensity -> {Null,Null,EqualP[2800 RPM]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PelletCentrifugeIntensity bioSTAR resolution *)
    Example[{Options,PelletCentrifugeIntensity,"PelletCentrifugeIntensity option is set to 3600g if SeparationTechnique is set to Pellet, otherwise FilterCentrifugeIntensity is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Filter,Filter,Pellet},
        WorkCell -> bioSTAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
      KeyValuePattern[
        {
          PelletCentrifugeIntensity -> {Null,Null,EqualP[3600 GravitationalAcceleration]}
        }
      ]},

      TimeConstraint -> 3200
    ],

    (* Test SupernatantVolume resolution *)
    Example[{Options,SupernatantVolume,"SupernatantVolume option is set to 90% of the sample volume plus PrecipitationReagentVolume if SeparationTechnique is set to Pellet, otherwise SupernatantVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitationReagentVolume -> {0.5 Milliliter,Automatic,Automatic},
        SeparationTechnique -> {Pellet,Pellet,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          SupernatantVolume -> {EqualP[Quantity[0.675,"Milliliters"]],EqualP[Quantity[0.338,"Milliliters"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test NumberOfWashes resolution *)
    Example[{Options,NumberOfWashes,"NumberOfWashes option is set to 3 if TargetPhase is set to Solid, otherwise NumberOfWashes is set to 0:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          NumberOfWashes -> {EqualP[3],EqualP[0]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashSolution resolution *)
    Example[{Options,WashSolution,"WashSolution option is set to Model[Sample, StockSolution, \"id:BYDOjv1VA7Zr\"] if NumberOfWashes is set to a number greater than 0, otherwise WashSolution is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        NumberOfWashes -> {0,1,Null},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashSolution -> {Null,ObjectP[Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashSolutionVolume resolution *)
    Example[{Options,WashSolutionVolume,"WashSolutionVolume option is set to the volume of the sample if NumberOfWashes is set to a number greater than 0, otherwise WashSolutionVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        NumberOfWashes -> {0,1,Null},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashSolutionVolume -> {Null,EqualP[Quantity[0.25,"Milliliters"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashSolutionTemperature resolution *)
    Example[{Options,WashSolutionTemperature,"WashSolutionTemperature option is set to Ambient if NumberOfWashes is set to a number greater than 0, otherwise WashSolutionTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        NumberOfWashes -> {0,1,Null},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashSolutionTemperature -> {Null,Ambient,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashSolutionEquilibrationTime resolution *)
    Example[{Options,WashSolutionEquilibrationTime,"WashSolutionEquilibrationTime option is set to 10 Minute if NumberOfWashes is set to a number greater than 0, otherwise WashSolutionEquilibrationTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        NumberOfWashes -> {0,1,Null},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashSolutionEquilibrationTime -> {Null,EqualP[10 Minute],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixType resolution *)
    Example[{Options,WashMixType,"WashMixType option is set properly based on TargetPhase, WashMixBolume, NumberOfWashes, and WashMixVolume, otherwise WashMixType is set to None - Test 1:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        NumberOfWashes -> {Automatic,Automatic},
        NumberOfWashMixes -> {1,Automatic},
        WashMixVolume -> {Automatic,1 Microliter},
        TargetPhase -> {Solid,Solid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixType -> Pipette
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixType resolution *)
    Example[{Options,WashMixType,"WashMixType option is set properly based on TargetPhase, WashMixBolume, NumberOfWashes, and WashMixVolume, otherwise WashMixType is set to None - Test 2:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        NumberOfWashes -> {Automatic,Automatic},
        NumberOfWashMixes -> {Automatic,Automatic},
        WashMixVolume -> {Automatic,Automatic},
        TargetPhase -> {Solid,Liquid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixType -> {Shake,None}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixInstrument STAR resolution *)
    Example[{Options,WashMixInstrument,"WashMixInstrument option is set for STAR workcell based on WashMixType, WashMixTemperature, SeparationTechnique, and WashMixRate - Test 1:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette},
        WashMixTemperature -> {Automatic,Automatic},
        SeparationTechnique -> {Pellet,Pellet},
        WashMixRate -> {Automatic,Automatic},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixInstrument -> {ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixInstrument STAR resolution *)
    Example[{Options,WashMixInstrument,"WashMixInstrument option is set for STAR workcell based on WashMixType, WashMixTemperature, SeparationTechnique, and WashMixRate - Test 2:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {None,Shake},
        WashMixTemperature -> {Automatic,65 Celsius},
        SeparationTechnique -> {Pellet,Pellet},
        WashMixRate -> {Automatic,Automatic},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixInstrument -> {Null,ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],
    (* Test WashMixInstrument bioSTAR resolution *)
    Example[{Options,WashMixInstrument,"WashMixInstrument option is set for bioSTAR workcell based on WashMixType, WashMixTemperature, SeparationTechnique, and WashMixRate:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette,None,Shake,Shake},
        WashMixTemperature -> {Automatic,Automatic,Automatic,65 Celsius,72 Celsius},
        WorkCell -> bioSTAR,
        WashMixRate -> {Automatic,Automatic,Automatic,300 RPM,500 RPM},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
      KeyValuePattern[
        {
          WashMixInstrument -> {ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]],Null,Null,ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]],ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixRate resolution *)
    Example[{Options,WashMixRate,"WashMixRate option is set to 300 RPM if WashMixType is set to Shake, Otherwise WashMixRate is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixRate -> {Quantity[300,("Revolutions") / ("Minutes")],Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixTemperature resolution *)
    Example[{Options,WashMixTemperature,"WashMixTemperature option is set to Ambient if WashMixType is set to Shake, Otherwise WashMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixTemperature -> {Ambient,Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],


    (* Test WashMixTime resolution *)
    Example[{Options,WashMixTime,"WashMixTime option is set to 15 Minute if WashMixType is set to Shake, Otherwise WashMixTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixTime -> {Quantity[15,"Minutes"],Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test NumberOfWashMixes resolution *)
    Example[{Options,NumberOfWashMixes,"NumberOfWashMixes option is set to 10 if WashMixType is set to Pippete, Otherwise WashMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          NumberOfWashMixes -> {Null,10,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashMixVolume resolution *)
    Example[{Options,WashMixVolume,"WashMixVolume option is set properly based on sample size if WashMixType is set to Pippete, Otherwise WashMixVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashMixVolume -> {Null,EqualP[Quantity[0.125,Milliliter]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashPrecipitationTemperature resolution *)
    Example[{Options,WashPrecipitationTemperature,"WashPrecipitationTemperature option is set Ambient if WashMixType is set to greater than 0 Minute, Otherwise WashPrecipitationTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashPrecipitationTime -> {Null,0 Minute,1 Minute},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashPrecipitationTemperature -> {Null,Null,Ambient}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashPrecipitationTime resolution *)
    Example[{Options,WashPrecipitationTime,"WashPrecipitationTime option is set 1 Minute if WashSolutionTemperature is more than PrecipitationReagentTemperature, Otherwise WashPrecipitationTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashSolutionTemperature -> {25 Celsius,50 Celsius,50 Celsius},
        PrecipitationReagentTemperature -> {50 Celsius,25 Celsius,50 Celsius},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashPrecipitationTime -> {Null,1 Minute,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashPrecipitationInstrument resolution *)
    Example[{Options,WashPrecipitationInstrument,"WashPrecipitationInstrument option is set properly based on WashPrecipitationTemperature and SeparationTechnique or is set to Null if WashPrecipitationTime is not greater than 0 Minute:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        WashPrecipitationTime -> {Null,0 Minute,15 Minute,15 Minute},
        WashPrecipitationTemperature -> {Automatic,Automatic,26 Celsius,Automatic},
        SeparationTechnique -> {Pellet,Pellet,Filter,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashPrecipitationInstrument -> {Null,Null,ObjectP[Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]],ObjectP[Model[Instrument,HeatBlock,"id:R8e1Pjp1W39a"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashCentrifugeIntensity resolution *)
    Example[{Options, {WashCentrifugeIntensity, WashPressure}, "WashCentrifugeIntensity option is set to 4000 g if FiltrationTechnique is set to Centrifuge or if SeparationTechnique is set to Pellet, WashPressure option is set to 40 PSI if FiltrationTechnique is set to AirPressure:"},
      ExperimentPrecipitate[
        {
          Object[Sample, "DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample, "DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        SampleVolume -> {100 Microliter, 50 Microliter, 250 Microliter},
        WashSolutionVolume -> {100 Microliter, 50 Microliter, 250 Microliter},
        NumberOfWashes -> 1,
        FiltrationTechnique -> {Automatic, Centrifuge, AirPressure},
        SeparationTechnique -> {Pellet, Filter, Filter},
        WorkCell -> STAR,
        Output -> Options
      ],
      KeyValuePattern[
        {
          WashCentrifugeIntensity -> {EqualP[2800 RPM], EqualP[2800 RPM], Null},
          WashPressure -> {Null, Null, EqualP[40 PSI]}
        }
      ],
      TimeConstraint -> 3200
    ],

    (* Test WashSeparationTime resolution (FiltrationTechnique AirPressure Only) *)
    Example[{Options, WashSeparationTime, "WashSeparationTime option is properly set based on SeparationTechnique, FiltrationTechnique (AirPressure Only), and NumberOfWashes:"},
      ExperimentPrecipitate[
        {
          Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        FiltrationTechnique -> {Null, Null, AirPressure, AirPressure},
        SeparationTechnique -> {Pellet, Pellet, Filter, Filter},
        NumberOfWashes -> {0, 3, 3, 0},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashSeparationTime -> {Null, EqualP[20 Minute], EqualP[3 Minute], Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashSeparationTime resolution (FiltrationTechnique Centrifuge Only) *)
    Example[{Options, WashSeparationTime, "WashSeparationTime option is properly set based on SeparationTechnique, FiltrationTechnique (Pellet Only), and NumberOfWashes:"},
      ExperimentPrecipitate[
        {
          Object[Sample, "DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        FiltrationTechnique -> {Null, Null},
        SeparationTechnique -> {Pellet, Pellet},
        NumberOfWashes -> {0, 3},
        Output -> {Result, Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          WashSeparationTime -> {Null, EqualP[20 Minute]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test WashSeparationTime resolution (FiltrationTechnique Centrifuge Only) *)
    Example[{Options, WashSeparationTime, "WashSeparationTime option is properly set based on SeparationTechnique, FiltrationTechnique (Filter Centrifuge Only), and NumberOfWashes:"},
      ExperimentPrecipitate[
        {
          Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
        },
        SampleVolume -> {100 Microliter, 100 Microliter},
        FiltrationTechnique -> {Centrifuge, Centrifuge},
        SeparationTechnique -> {Filter, Filter},
        NumberOfWashes -> {3, 0},
        Output -> Options
      ],
      KeyValuePattern[
        {
          WashSeparationTime -> {EqualP[20 Minute], Null}
        }
      ],
      TimeConstraint -> 3200
    ],

    (* Test DryingTemperature resolution *)
    Example[{Options,DryingTemperature,"DryingTemperature option is set to Ambient if TargetPhase is set to Solid, Otherwise DryingTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          DryingTemperature -> {Ambient,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test DryingTime resolution *)
    Example[{Options,DryingTime,"DryingTime option is set to 20 Minute if TargetPhase is set to Solid, Otherwise DryingTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          DryingTime -> {EqualP[20 Minute],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionBuffer resolution *)
    Example[{Options,ResuspensionBuffer,"ResuspensionBuffer option is set to Model[Sample, StockSolution, \"id:n0k9mGzRaJe6\"] if TargetPhase is set to Solid, Otherwise ResuspensionBuffer is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionBuffer -> {ObjectP[Model[Sample,StockSolution,"id:n0k9mGzRaJe6"]],None}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionBufferVolume resolution *)
    Example[{Options,ResuspensionBufferVolume,"ResuspensionBufferVolume option is set to the greater of 10 MicroLiter or 1/4th SampleVolume, Otherwise ResuspensionBufferVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 9.0 uL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionBuffer -> {Null,Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],Model[Sample,StockSolution,"id:n0k9mGzRaJe6"]},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionBufferVolume -> {Null,EqualP[0.06 Milliliter],EqualP[10 Microliter]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionBufferTemperature resolution *)
    Example[{Options,ResuspensionBufferTemperature,"ResuspensionBufferTemperature option is set to Ambient if ResuspensionBuffer is set, Otherwise ResuspensionBufferVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionBuffer -> {Null,Model[Sample,StockSolution,"id:n0k9mGzRaJe6"]},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionBufferTemperature -> {Null,Ambient}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionBufferEquilibrationTime resolution *)
    Example[{Options,ResuspensionBufferEquilibrationTime,"ResuspensionBufferEquilibrationTime option is set to 10 Minute if ResuspensionBuffer is set, Otherwise ResuspensionBufferEquilibrationTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionBuffer -> {Null,Model[Sample,StockSolution,"id:n0k9mGzRaJe6"]},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionBufferEquilibrationTime -> {Null,EqualP[10 Minute]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixType resolution Test 1, split due to deck space issues*)
    Example[{Options,ResuspensionMixType,"ResuspensionMixType option is properly set based on ResuspensionBuffer, ResuspensionMixVolume, and NumberOfResuspensionMixes Test 1:"},
      ExperimentPrecipitate[{Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionBuffer -> {Null,None,Model[Sample,StockSolution,"id:n0k9mGzRaJe6"]},
        ResuspensionMixVolume -> {Null,Null,Automatic},
        NumberOfResuspensionMixes -> {Null,Null,10},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixType -> {None,None,Pipette}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixType resolution Test 2, split due to deck space issues*)
    Example[{Options,ResuspensionMixType,"ResuspensionMixType option is properly set based on ResuspensionBuffer, ResuspensionMixVolume, and NumberOfResuspensionMixes Test 2:"},
      ExperimentPrecipitate[{Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionBuffer -> {Model[Sample,StockSolution,"id:n0k9mGzRaJe6"],Model[Sample,StockSolution,"id:n0k9mGzRaJe6"]},
        ResuspensionMixVolume -> {Null,Automatic},
        NumberOfResuspensionMixes -> {Null,10},
        Output -> {Result,Options}],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixType -> {Shake,Pipette}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixInstrument STAR resolution *)
    Example[{Options,ResuspensionMixInstrument,"ResuspensionMixInstrument option is set for STAR workcell based on ResuspensionMixType, ResuspensionMixTemperature, SeparationTechnique, and ResuspensionMixRate - Test 1:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette},
        ResuspensionMixTemperature -> {Automatic,Automatic},
        SeparationTechnique -> {Pellet,Pellet},
        WorkCell -> STAR,
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixInstrument -> {ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitationMixInstrument STAR resolution *)
    Example[{Options,ResuspensionMixInstrument,"ResuspensionMixInstrument option is set for STAR workcell based on ResuspensionMixType, ResuspensionMixTemperature, SeparationTechnique, and ResuspensionMixRate - Test 2:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {None,Shake,Shake},
        ResuspensionMixTemperature -> {Automatic,27 Celsius,65 Celsius},
        SeparationTechnique -> {Pellet,Pellet,Pellet},
        WorkCell -> STAR,
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixInstrument -> {Null,ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]],ObjectP[Model[Instrument,Shaker,"id:KBL5Dvw5Wz6x"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixInstrument bioSTAR resolution *)
    Example[{Options,ResuspensionMixInstrument,"ResuspensionMixInstrument option is set for bioSTAR workcell based  on ResuspensionMixType, ResuspensionMixTemperature, SeparationTechnique, and ResuspensionMixRate:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette,None,Shake,Shake},
        ResuspensionMixTemperature -> {Automatic,Automatic,Automatic,65 Celsius,72 Celsius},
        WorkCell -> bioSTAR,
        ResuspensionMixRate -> {Automatic,Automatic,Automatic,300 RPM,500 RPM},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticCellPreparation]],
      KeyValuePattern[
        {
          ResuspensionMixInstrument -> {ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]],Null,Null,ObjectP[Model[Instrument, Shaker, "id:pZx9jox97qNp"]],ObjectP[Model[Instrument,Shaker,"id:eGakldJkWVnz"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixRate resolution *)
    Example[{Options,ResuspensionMixRate,"ResuspensionMixRate option is set to 300 RPM if ResuspensionMixType is set to Shake, Otherwise ResuspensionMixRate is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixRate -> {Quantity[300,("Revolutions") / ("Minutes")],Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixTemperature resolution *)
    Example[{Options,ResuspensionMixTemperature,"ResuspensionMixTemperature option is set to Ambient if ResuspensionMixType is set to Shake, Otherwise ResuspensionMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixTemperature -> {Ambient,Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixTime resolution *)
    Example[{Options,ResuspensionMixTime,"ResuspensionMixTime option is set to 15 Minute if ResuspensionMixType is set to Shake, Otherwise ResuspensionMixTime is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixTime -> {Quantity[15,"Minutes"],Null,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test NumberOfResuspensionMixes resolution *)
    Example[{Options,NumberOfResuspensionMixes,"NumberOfResuspensionMixes option is set to 10 if ResuspensionMixType is set to Pippete, Otherwise ResuspensionMixTemperature is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette,None},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          NumberOfResuspensionMixes -> {Null,10,Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test ResuspensionMixVolume resolution *)
    Example[{Options,ResuspensionMixVolume,"ResuspensionMixVolume option is set properly based on sample size if ResuspensionMixType is set to Pippete, Otherwise ResuspensionMixVolume is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        ResuspensionMixType -> {Shake,Pipette,None,Pipette},
        ResuspensionBufferVolume -> {Automatic,Automatic,Automatic,1 Milliliter},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          ResuspensionMixVolume -> {Null,EqualP[Quantity[0.03,Milliliter]],Null,EqualP[Quantity[0.5,Milliliter]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitatedSampleStorageCondition resolution *)
    Example[{Options,PrecipitatedSampleStorageCondition,"PrecipitatedSampleStorageCondition option is set to the StorageCondition of the Sample if TargetPhase is set to Solid, otherwise PrecipitatedSampleStorageCondition is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitatedSampleStorageCondition -> {ObjectP[Model[StorageCondition,"Refrigerator"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test UnprecipitatedSampleStorageCondition resolution *)
    Example[{Options,UnprecipitatedSampleStorageCondition,"UnprecipitatedSampleStorageCondition option is set to the StorageCondition of the Sample if TargetPhase is set to Liquid, otherwise UnprecipitatedSampleStorageCondition is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Liquid,Solid},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          UnprecipitatedSampleStorageCondition -> {ObjectP[Model[StorageCondition,"Refrigerator"]],Null}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test FilterStorageCondition resolution *)
    Example[{Options,FilterStorageCondition,"FilterStorageCondition option is set to the StorageCondition of the Sample if TargetPhase is set to Solid, otherwise FilterStorageCondition is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid},
        SeparationTechnique -> {Filter,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          FilterStorageCondition -> {ObjectP[Model[StorageCondition,"Refrigerator"]],Disposal}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitatedSampleLabel resolution *)
    Example[{Options,PrecipitatedSampleLabel,"PrecipitatedSampleLabel option is set if TargetPhase is set to Solid, otherwise PrecipitatedSampleLabel is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Liquid,Solid,Solid},
        PrecipitatedSampleLabel -> {Automatic,Automatic,"Test Label"},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitatedSampleLabel -> {Null,_String,"Test Label"}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PrecipitatedSampleContainerLabel resolution *)
    Example[{Options,PrecipitatedSampleContainerLabel,"PrecipitatedSampleContainerLabel option is set if TargetPhase is set to Solid, otherwise PrecipitatedSampleContainerLabel is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Liquid,Solid,Solid},
        PrecipitatedSampleContainerLabel -> {Automatic,Automatic,"Test Label"},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitatedSampleContainerLabel -> {Null,_String,"Test Label"}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test UnprecipitatedSampleLabel resolution *)
    Example[{Options,UnprecipitatedSampleLabel,"UnprecipitatedSampleLabel option is set if TargetPhase is set to Liquid, otherwise UnprecipitatedSampleLabel is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid,Liquid},
        UnprecipitatedSampleLabel -> {Automatic,Automatic,"Test Label"},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          UnprecipitatedSampleLabel -> {Null,_String,"Test Label"}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test UnprecipitatedSampleContainerLabel resolution *)
    Example[{Options,UnprecipitatedSampleContainerLabel,"UnprecipitatedSampleContainerLabel option is set if TargetPhase is set to Liquid, otherwise UnprecipitatedSampleContainerLabel is set to Null:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        TargetPhase -> {Solid,Liquid,Liquid},
        UnprecipitatedSampleContainerLabel -> {Automatic,Automatic,"Test Label"},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          UnprecipitatedSampleContainerLabel -> {Null,_String,"Test Label"}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test Container Packing for Precipitated Samples resolution *)
    Example[{Options,PrecipitatedSampleContainerOut,"PrecipitatedSampleContainer is set properly based on input, Test 1:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitatedSampleContainerOut -> {
          {1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
          {"A1",{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]}},
          Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PrecipitatedSampleContainerOut -> {
            {1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]},
            {"A1",{1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}},
            ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],
    (* Test Container Packing for Precipitated Samples resolution *)
    Example[{Options,PrecipitatedSampleContainerOut,"PrecipitatedSampleContainer is set properly based on input, Test 2:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        PrecipitatedSampleContainerOut -> {
          Automatic,
          Automatic},
        NumberOfWashes -> 1,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        KeyValuePattern[
          {
            PrecipitatedSampleContainerOut -> {
              {"A1",{1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}},
              {"B1",{1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}}}
          }
        ]},
      TimeConstraint -> 3200
    ],
    
    (* Test Container Packing for Unprecipitated Samples resolution *)
    Example[{Options,UnprecipitatedSampleContainerOut,"UnprecipitatedSampleContainer is set properly based on input Test 1:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        UnprecipitatedSampleContainerOut -> {
          {1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
          {"A1",{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]}},
          Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          UnprecipitatedSampleContainerOut -> {
            {1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]},
            {"A1",{1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}},
            ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],
    (* Test Container Packing for Unprecipitated Samples resolution *)
    Example[{Options,UnprecipitatedSampleContainerOut,"UnprecipitatedSampleContainer is set properly based on input Test 2:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        UnprecipitatedSampleContainerOut -> {
          Automatic,
          Automatic},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        KeyValuePattern[
          {
            UnprecipitatedSampleContainerOut -> {
              {"A1",{2,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}},
              {"B1",{2,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]}}}
          }
        ]},
      TimeConstraint -> 3200
    ],
    
    (* Test Filter resolution *)
    Example[{Options,Filter,"Filter option is set to Null if SeparationTechnique is set to Pellet, otherwise it is set by ExperimentFilter resolver:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Pellet,Filter},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          Filter -> {Null,ObjectP[Model[Container,Plate,Filter,"id:xRO9n3voKKm6"]]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test PoreSize resolution *)
    Example[{Options,PoreSizes,"PoreSizes option is set to Null if SeparationTechnique is set to Pellet, otherwise it is set by ExperimentFilter resolver:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Pellet,Filter},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          PoreSize -> {Null,EqualP[0.22 Micrometer]}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test MembraneMaterial resolution *)
    Example[{Options,MembraneMaterial,"MembraneMaterials option is set to Null if SeparationTechnique is set to Pellet, otherwise it is set by ExperimentFilter resolver:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Pellet,Filter},
        WorkCell -> STAR,
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          MembraneMaterial -> {Null,PTFE}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Test FilterPosition resolution *)
    Example[{Options,FilterPosition,"FilterPosition option is set to Null if SeparationTechnique is set to Pellet, otherwise it is set by ExperimentFilter resolver:"},
      ExperimentPrecipitate[
        {Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]},
        SeparationTechnique -> {Pellet,Filter},
        Output -> {Result,Options}
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
      KeyValuePattern[
        {
          FilterPosition -> {Null,"A1"}
        }
      ]},
      TimeConstraint -> 3200
    ],

    (* Messages tests *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentPrecipitate[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentPrecipitate[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentPrecipitate[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentPrecipitate[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"2mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 0.5 Milliliter,
          CellType -> Mammalian,
          CultureAdhesion -> Adherent,
          Living -> True,
          State -> Liquid
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentPrecipitate[sampleID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          {{100 MassPercent, Model[Cell, Mammalian, "HEK293"]}},
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 0.5 Milliliter,
          CellType -> Mammalian,
          CultureAdhesion -> Adherent,
          Living -> True,
          State -> Liquid
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentPrecipitate[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages,"SeparationTechniqueConflictingOptions","Return an Error if there are conflicting separation technique options set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        SeparationTechnique -> Pellet,
        PelletCentrifuge -> Null,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::SeparationTechniqueConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"NotWashingConflictingOptions","Return an Error if there NumberOfWashes is set to Null or Zero but other wash Options are set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        NumberOfWashes -> 0,
        WashSolutionVolume -> 100 Microliter,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::NotWashingConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"DryingSolidConflictingOptions","Return an Error if there DryingTime and DryingTemperature are both set or both not set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        DryingTime -> 0 Minute,
        DryingTemperature -> Ambient,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::DryingSolidConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"ResuspensionBufferConflictingOptions","Return an Error if the ResuspensionBuffer and ResuspensionBufferVolume are not both set both not set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        ResuspensionBuffer -> Model[Sample,StockSolution,"id:AEqRl954GJb6"],
        ResuspensionBufferVolume -> 0 Microliter,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::ResuspensionBufferConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"PreIncubationTemperatureNotSpecified","Return an Error if WashSolutionTemperature is Null but WashSolutionEquilibrationTime is set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        WashSolutionTemperature -> Null,
        WashSolutionEquilibrationTime -> 10 Minute,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::PreIncubationTemperatureNotSpecified,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"PrecipitationMixTypeConflictingOptions","Return an Error if PrecipitationBufferMixType is set to None but some Precipitation Mix Options are set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        PrecipitationMixType -> None,
        PrecipitationMixVolume -> 10 Microliter,
        NumberOfPrecipitationMixes -> 2,
        PrecipitationMixTemperature -> 10 Celsius,
        PrecipitationMixTime -> 10 Minute,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::PrecipitationMixTypeConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"WashMixTypeConflictingOptions","Return an Error if WashBufferMixType is set to None but some Wash Mix Options are set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        WashMixType -> None,
        WashMixVolume -> 10 Microliter,
        NumberOfWashMixes -> 2,
        WashMixTemperature -> 10 Celsius,
        WashMixTime -> 10 Minute,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::WashMixTypeConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ],

    Example[{Messages,"ResuspensionMixTypeConflictingOptions","Return an Error if ResuspensionBufferMixType is set to None but some Resuspension Mix Options are set:"},
      ExperimentPrecipitate[
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        ResuspensionMixType -> None,
        ResuspensionMixVolume -> 10 Microliter,
        NumberOfResuspensionMixes -> 2,
        ResuspensionMixTemperature -> 10 Celsius,
        ResuspensionMixTime -> 10 Minute,
        Output -> {Result}
      ],
      {$Failed},
      Messages :> {
        Error::ResuspensionMixTypeConflictingOptions,
        Error::InvalidOption
      },
      TimeConstraint -> 3200
    ]
  },
  Parallel -> True,
  SetUp :> (
    (* Turn off the lab state warning for unit tests, since parallel is True, warnings should be turned off in SetUp as well *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  TearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolSetUp :> Module[{existsFilter,plate0,plate1,plate2,plate3,plate4,plate5,plate6,tube0,sample0,sample1,sample2,sample3,sample4,sample5,sample6},
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Sample,"DNA in water sample 9.0 uL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Sample,"DNA in water sample 1.6mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 1 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 2 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 3 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 4 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 5 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 6 for ExperimentPrecipitate " <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 0 for ExperimentPrecipitate " <> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 9.0 uL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Sample,"DNA in water sample 1.6mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 1 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 2 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 3 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 4 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 5 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 6 for ExperimentPrecipitate " <> $SessionUUID],
          Object[Container,Vessel,"Test 50mL Tube 0 for ExperimentPrecipitate " <> $SessionUUID]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];


    {plate0} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {plate1} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 1 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {plate2} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 2 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {plate3} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 3 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {plate4} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 4 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {plate5} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 5 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {plate6} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 6 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    {tube0} = Upload[{
      <|
        Type -> Object[Container,Vessel],
        Model -> Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name -> "Test 50mL Tube 0 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0,sample1,sample2,sample3,sample4,sample5,sample6} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{100 VolumePercent,Model[Molecule,"Water"]}},
        {{100 VolumePercent,Model[Molecule,"Water"]}},
        {{100 VolumePercent,Model[Molecule,"Water"]}},
        {{100 VolumePercent,Model[Molecule,"Water"]}},
        {{100 VolumePercent,Model[Molecule,"Water"]}},
        {{100 VolumePercent,Model[Molecule,"Water"]}},
        {{100 VolumePercent,Model[Molecule,"Water"]}}
      },
      {
        {"A1",plate0},
        {"A1",plate1},
        {"A1",plate2},
        {"A1",plate3},
        {"A1",plate4},
        {"A1",plate5},
        {"A1",plate6}
      },
      Name -> {
        "DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID,
        "DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID,
        "DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID,
        "DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID,
        "DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID,
        "DNA in water sample 9.0 uL (Test for ExperimentPrecipitate) " <> $SessionUUID,
        "DNA in water sample 1.6mL (Test for ExperimentPrecipitate) " <> $SessionUUID
      },
      InitialAmount -> {
        0.25 Milliliter,
        0.25 Milliliter,
        0.25 Milliliter,
        0.25 Milliliter,
        0.25 Milliliter,
        9.0 Microliter,
        1.6 Milliliter
      },

      State -> Liquid,
      FastTrack -> True,
      StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"]
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #,Status -> Available,DeveloperObject -> True|>& /@ {sample0}];

  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects,existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 2 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 3 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 4 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 5 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 9.0 uL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Sample,"DNA in water sample 1.6mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 1 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 2 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 3 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 4 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 5 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 6 for ExperimentPrecipitate " <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 0 for ExperimentPrecipitate " <> $SessionUUID]
      }],ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter = DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ]];
    ]
  )

];

(* ::Subsubsection::Closed:: *)
(*Precipitate*)
DefineTests[Precipitate,
  {
    Example[{Basic,"Form an precipitate unit operation:"},
      Precipitate[
        Sample -> Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID]
      ],
      _Precipitate
    ],
    Example[{Basic,"A RoboticSamplePreparation protocol is generated when calling Precipitate:"},
      ExperimentRoboticSamplePreparation[
        {
          Precipitate[
            Sample -> Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
            WorkCell -> STAR
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticSamplePreparation]],
      TimeConstraint -> 3200
    ],

    Example[{Basic,"A RoboticCellPreparation protocol is generated when calling Precipitate for use in the bioSTAR:"},
      ExperimentRoboticCellPreparation[
        {
          Precipitate[
            Sample -> Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
            WorkCell -> bioSTAR
          ]
        }
      ],
      ObjectP[Object[Protocol,RoboticCellPreparation]],
      TimeConstraint -> 3200
    ]
  },

  SymbolSetUp :> Module[{existsFilter,sample0,plate0},
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
      Object[Container,Plate,"Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
          Object[Container,Plate,"Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];


    {plate0} = Upload[{
      <|
        Type -> Object[Container,Plate],
        Model -> Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name -> "Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID,
        DeveloperObject -> True,
        Site -> Link[$Site]
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample0} = UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        {{100 VolumePercent,Model[Molecule,"Water"]}}
      },
      {
        {"A1",plate0}
      },
      Name -> {
        "DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID
      },
      InitialAmount -> {
        0.25 Milliliter
      },

      State -> Liquid,
      FastTrack -> True,
      StorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"]
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[<|Object -> #,Status -> Available,DeveloperObject -> True|>& /@ {sample0}];

  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects,existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = Cases[Flatten[{
        Object[Sample,"DNA in water sample 1 0.25mL (Test for ExperimentPrecipitate) " <> $SessionUUID],
        Object[Container,Plate,"Test Plate 0 for ExperimentPrecipitate " <> $SessionUUID]
      }],ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter = DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force -> True,
        Verbose -> False
      ]];
    ]
  )
];