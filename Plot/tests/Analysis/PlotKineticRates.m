(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*PlotKineticRates*)


DefineTests[PlotKineticRates,
  {
  	Example[{Basic,"Plot fitted kinetc rates:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"]],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Test["Given a link:",
  		PlotKineticRates[Link[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],Reference]],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Test["Given a packet:",
  		PlotKineticRates[Download[Object[Analysis, Kinetics, "id:qdkmxz0APe54"]]],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],

  	Example[{Options,PlotStyle,"Plot the predicted trajectories against the training data:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->Trajectories],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,PlotStyle,"Create a goodness of fit plot for the fitted rate values:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],

  	Example[{Options,Rates,"Create goodness of fit plot for one rate.  All other rates are held constant at their optimum values:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->kf],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,Rates,"Create contour plot goodness of fit plot for two rates:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->{kf,kb}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],

  	(* Example[{Options,Rates,"Create goodness of fit plot for three rate by making contour plots for all pairs of rates:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates -> {{kf, 10^{5, 6, 7}}, {kb, 10^{5, 6, 7}}, {kf3,10^{5, 6, 7}}}],
  		_,
  		TimeConstraint -> 900
  	], *)

  	Example[{Options,Rates,"Specify the range from which to sample the varying rate will be uniformly sampled:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->{kf,10^3,10^7}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,Rates,"Specify the range from which to sample the varying rate will be log-sampled:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->{kf,10^3,10^7,Log}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,Rates,"Sample kf at 25 points linearly spaced between 10^3 and 10^7:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->{kf,10^3,10^7,25}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,Rates,"Sample kf at 25 points logarithmically spaced between 10^3 and 10^7:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->{kf,10^3,10^7,25,Log}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,Rates,"Specify the exact values at which to sample the varying rate:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,Rates->{kf,{10^5,10^5.5,10^5,10^5.5,10^6,10^6.5}}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],


  	Example[{Options,PlotType,"Specify axes for goodness of fit plot:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],PlotStyle->GoodnessOfFit,PlotType->{Linear,Log}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],


  	Example[{Options,FeatureDisplay,"Display no epliogs:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:AEqRl9Kzl70v"],PlotStyle->GoodnessOfFit,FeatureDisplay->{}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],
  	Example[{Options,FeatureDisplay,"Display the best fit point and the minimum of the sampled points, which might not match:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:AEqRl9Kzl70v"],PlotStyle->GoodnessOfFit,FeatureDisplay->{BestFit,SampleMinimum}],
  		ValidGraphicsP[],
  		TimeConstraint -> 900
  	],


  	Example[{Options,Legend,"Specify a legend:"},
  		PlotKineticRates[Object[Analysis, Kinetics, "id:qdkmxz0APe54"],Legend->{"Evaluated points","Interpolation"}],
  		_?Core`Private`ValidLegendedQ,
  		TimeConstraint -> 900
  	]

  }
];
