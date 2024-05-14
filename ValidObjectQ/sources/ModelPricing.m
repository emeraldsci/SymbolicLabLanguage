(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelPricingQTests*)

validModelPricingQTests[packet:PacketP[Model[Pricing]]] := {

  NotNullFieldTest[packet,
    {
      PricingPlanName,
      PlanType,
      CommitmentLength,
      NumberOfBaselineUsers,
      CommandCenterPrice,
      ConstellationPrice,
      NumberOfThreads,
      LabAccessFee,
      PricePerExperiment,
      OperatorTimePrice,
      InstrumentPricing,
      CleanUpPricing,
      StockingPricing,
      WastePricing,
      StoragePricing
    }
  ]
};

(* ::Subsection::Closed:: *)
(* Test Registration *)

registerValidQTestFunction[Model[Pricing],validModelPricingQTests];