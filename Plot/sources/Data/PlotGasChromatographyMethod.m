(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotGasChromatographyMethod*)


DefineOptions[PlotGasChromatographyMethod,
	Options :> {
		{
			PlotRange->{Automatic,Automatic},
			Automatic|All|Full| {Automatic|All|Full|_?UnitsQ| {Automatic|All|Full|_?UnitsQ, Automatic|All|Full|_?UnitsQ},
				Automatic|All|Full|_?UnitsQ| {Automatic|All|Full|_?UnitsQ,Automatic|All|Full|_?UnitsQ}},
			"PlotRange specification for the primary data.  PlotRange units must be compatible with units of primary data."},
		{Legend->Automatic,NullP|Automatic|ListableP[(_String|_Style|Null),2]|None,
			"Specification for legend associated with primary data."}
	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


PlotGasChromatographyMethod[myObject:ObjectP[Object[Method,GasChromatography]],ops:OptionsPattern[PlotGasChromatographyMethod]]:=Module[
	{
		myMethodPacket,myColumnParameters,columnLengths,columnDiameters,myInletLinerParameters,legend,mmiInitialTemperature,mmiInitialHoldTime,mmiTemperatureRampProfile,
		inletTemperatureTimeProfile,initialOvenTemperature,
		initialOvenHoldTime,columnOvenTemperatureRampProfile,columnOvenTemperatureTimeProfile,gcColumnMode,initialColumnFlowRate,initialColumnPressure,
		initialColumnAverageVelocity,initialColumnHoldupTime,initialColumnSetpointDuration,columnPressureRampProfile,columnFlowRateRampProfile,
		initialColumnSetpoint,initialInletPressure,initialInletTime,splitRatio,splitVentFlowRate,splitlessPurgeFlowRate,splitlessTime,
		gasSaverFlowRate,gasSaverActivationTime,mmiSolventEliminationFlowRate,mmiSolventVentPressure,mmiSolventVentTime,columnProfile,columnTimeProfile,
		outletPressure,carrierGas,interpolatedColumnFlowRateProfile,interpolatedColumnProfile,interpolatedOvenProfile,columnMirrorTimeProfile,
		interpolatedColumnPressureProfile,pulsedInletPressureFunction,solventVentPressureFunction,pulsedInjection,columnPressureTimeProfile,
		columnFlowRateTimeProfile,solventVent,referenceTemperature,referencePressure,
		initialOvenTemperatureDuration, ovenTemperatureProfile, initialInletTemperature, initialInletTemperatureDuration, inletTemperatureProfile,
		columnPressureProfile, columnFlowRateProfile, methodTime, columnFlowRateTimeProfileInitial, columnPressureTimeProfileInitial, plotOption,
		temperaturePlot, pressureFlowPlot
	},

	(* Download all the Method information *)
	myMethodPacket=Switch[myObject,
		PacketP[],myObject,
		_,Download[myObject]
	];
	(* Download the column length and diameter *)
	myColumnParameters=If[
		MatchQ[Lookup[myMethodPacket,Column],{ObjectP[{Model[Item,Column],Object[Item,Column]}]..}],
		Download[Lookup[myMethodPacket,Column],{Diameter,ColumnLength}],
		{{0.32*Milli*Meter},{30*Meter}}
	];
	columnDiameters=First@myColumnParameters;
	columnLengths=Last@myColumnParameters;
	(*  *)
	outletPressure=If[
		MatchQ[Lookup[myMethodPacket,Detector],MassSpectrometer],
		-14.7*PSI,
		0*PSI
	];
	carrierGas=Lookup[myMethodPacket,CarrierGas];

	(* Helper function to convert ramp rate profiles into {{time,setpoint}...} form *)
	rampProfileConversion[initialSetpoint_, initialHoldTime_, rampProfile_] := Module[
		{firstPoints, profile},

		(* create the first points *)
		firstPoints = {{0*Minute, initialSetpoint}, {initialHoldTime, initialSetpoint}};

		(* switch depending on what we're given *)
		profile = DeleteDuplicates[
			Fold[
				Fold[
					Append,
					#1,
					{
						{(#2[[2]] - Last[#1][[2]])/#2[[1]] + Last[#1][[1]],
							#2[[2]]},
						{(#2[[2]] - Last[#1][[2]])/#2[[1]] + Last[#1][[1]] + #2[[3]],
							#2[[2]]}
					}] &,
				firstPoints,
				rampProfile]
		]
	];

	(* overload for non oven profiles *)
	rampProfileConversion[initialSetpoint_, initialHoldTime_, rampProfile_, extensionTime_] := Module[
		{firstPoints, profile, trimProfileQ, finalProfile},

		(* create the first points *)
		firstPoints = {{0*Minute, initialSetpoint}, {initialHoldTime, initialSetpoint}};

		(* switch depending on what we're given *)
		profile = Switch[
			{initialSetpoint, initialHoldTime, rampProfile},
			(* if everything is filled out, that's very nice *)
			{_Quantity, _Quantity, _Quantity},
			DeleteDuplicates[
				Fold[
					Fold[
						Append,
						#1,
						{
							{(#2[[2]] - Last[#1][[2]])/#2[[1]] + Last[#1][[1]],
								#2[[2]]},
							{(#2[[2]] - Last[#1][[2]])/#2[[1]] + Last[#1][[1]] + #2[[3]],
								#2[[2]]}
						}] &,
					firstPoints,
					rampProfile]
			],
			(* we might get a case where we only have an initial and nothing else, or a symbol from ConstantFlowRate/ConstantPressure/Isothermal whatever. This usually means we have a constant instead of profile behavior *)
			{_Quantity, Null, (Null|_Symbol)},
			(* extend to the last *)
			{{0*Minute, initialSetpoint}, {extensionTime, initialSetpoint}}
		];

		(* we'll need to trim if the profile goes beyond the extension time *)
		trimProfileQ = First[Last[profile]] > extensionTime;

		finalProfile = If[trimProfileQ,
			Module[
				{finalPoint, trimmedProfile, appendedProfile},
				(* get the final point allowed *)
				finalPoint = Interpolation[profile,extensionTime,InterpolationOrder->1];

				(* trim the profile *)
				trimmedProfile = Replace[profile,{{GreaterP[extensionTime],_} -> Nothing}];

				(* replace the last point with our created final point *)
				appendedProfile = Append[trimmedProfile, {extensionTime,finalPoint}]
			],
			profile
		]
	];

	(* Helper variables for column conversions *)
	referenceTemperature=298*Kelvin;
	referencePressure=1*Atmosphere;

	(* figure out from the method what the profiles look like *)
	(* oven params *)
	{initialOvenTemperature,initialOvenTemperatureDuration,ovenTemperatureProfile} = Module[
		{profile,initialTemp,initialTempDuration},
		(* for each set point and profile inside the option, we need to transform that profile into a ramp rate profile *)
		{profile,initialTemp,initialTempDuration} = Lookup[myMethodPacket,{OvenTemperatureProfile,InitialOvenTemperature,InitialOvenTemperatureDuration}];
		(* check what kind of profile we are dealing with *)
		Switch[
			profile,
			(* we may have a time/temperature profile *)
			{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
			(* in which case we are assuming linear connections between the profile points *)
			{
				initialTemp,
				Sequence@@Module[{fullProfile,flatRampProfile, updatedInitialTempDuration, updatedFlatRampProfile, paddedRampProfile, partitionedRampProfile, finalRampProfile},
					(* create the full profile *)
					fullProfile = Join[
						{
							(* check that initialTemp exists before making the zero point. *)
							Sequence@@If[NullQ[initialTemp],
								Nothing,
								{
									(* set the temperature at zero *)
									{0*Minute,initialTemp},
									(* check to make sure that the duration is not zero or null before making a second point *)
									If[NullQ[initialTempDuration] || MatchQ[initialTempDuration,EqualP[0*Minute]],
										Nothing,
										{initialTempDuration,initialTemp}
									]
								}
							]
						},
						(* check out what's going on with the profile compared to the 2 initial points *)
						Which[
							(* if our profile doesn't start at zero, but there are no initial points defined, throw an error *)
							!MatchQ[First[First[profile]],EqualP[0*Minute]] && NullQ[initialTemp],
							Message[Error::ProfileDoesNotStartAtZero];
							Return[$Failed],
							(* if there are initial parameters specified but the specified profile starts at zero, throw an error *)
							!NullQ[initialTemp] && !NullQ[initialTempDuration] && MatchQ[First[First[profile]],EqualP[0*Minute]],
							Message[Error::ProfileIsOverSpecified];
							Return[$Failed],
							True,
							profile
						]
					];

					(* create a flat list of the profile contents *)
					flatRampProfile = Flatten@MapThread[Function[{firstPoint, secondPoint},
						(*If the first and second point have the same temperature, it's a hold step*)
						If[MatchQ[Last[firstPoint], EqualP[Last[secondPoint]]],
							(*return the difference in time between the two points*)
							{First[secondPoint] - First[firstPoint]},
							(*otherwise they are different, so return a ramp rate (\[CapitalDelta]T/\[CapitalDelta]t) and the \new temperature (T2)*)
							{(Last[secondPoint] - Last[firstPoint])/(First[secondPoint] - First[firstPoint]), Last[secondPoint]}
						]
					],
						{Most[Rest[fullProfile]], Rest[Rest[fullProfile]]}
					];

					(* there may be a profile that starts with a hold time, so if that's the case we have to add that duration to the defined duration *)
					{updatedInitialTempDuration,updatedFlatRampProfile} = If[CompatibleUnitQ[First[flatRampProfile],Minute],
						initialTempDuration+First[flatRampProfile],Rest[flatRampProfile],
						initialTempDuration,flatRampProfile
					];

					(* next there's the case where the hold time after a ramp step is zero. *)
					paddedRampProfile = If[MatchQ[Partition[updatedFlatRampProfile,3],{{_?(CompatibleUnitQ[#,Kelvin/Minute]&),_?(CompatibleUnitQ[#,Kelvin]&),_?(CompatibleUnitQ[#,Minute]&)}...}],
						Return[{updatedInitialTempDuration,Partition[updatedFlatRampProfile,3]}],
						Flatten@SequenceReplace[flatProfile, {x_?(CompatibleUnitQ[#,Kelvin]&), y_?(CompatibleUnitQ[#, Kelvin/Minute] &)} :> {x, 0*Minute, y}]
					];

					(* now we can partitionRemainder the padded profile *)
					partitionedRampProfile = PartitionRemainder[paddedRampProfile,3];

					finalRampProfile = If[Length[Last[partitionedRampProfile]]==3,
						partitionedRampProfile,
						Join[Most[partitionedRampProfile],{Join[Last[partitionedRampProfile],{0*Minute}]}]
					];

					(* return the modified initialTempDuration and rampRateProfile *)
					{updatedInitialTempDuration,finalRampProfile}
				]
			},
			(* if we are given a ramp rate profile, that's great. *)
			{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
			{initialTemp,initialTempDuration,profile},
			(* setting a temperature in lieu of any initial conditions is allowed, but we will have to convert the profile to an initial temperature and null it out here. also todo: error check this in resolver *)
			{GreaterP[0*Kelvin],GreaterP[0*Minute]},
			{profile[[1]],profile[[2]],Null},
			(* and finally, setting the profile to Isothermal which implies that we are keeping the initial temperature throughout the run *)
			Isothermal,
			{initialTemp,initialTempDuration,Null},
			(* we can also get an empty list if no profile was set. this is equivalent to an isothermal, but we should do some option resolution to take care of this possibility so it's not ambiguous *)
			{},
			{initialTemp,initialTempDuration,Null}
		]
	];

	(* inlet params *)
	{initialInletTemperature,initialInletTemperatureDuration,inletTemperatureProfile} = Module[
		{profile,initialTemp,initialTempDuration},
		(* for each set point and profile inside the option, we need to transform that profile into a ramp rate profile *)
		{profile,initialTemp,initialTempDuration} = Lookup[myMethodPacket,{InletTemperatureProfile,InitialInletTemperature,InitialInletTemperatureDuration}];
		(* check what kind of profile we are dealing with *)
		Switch[
			profile,
			(* we may have a time/temperature profile *)
			{{GreaterEqualP[0*Minute],GreaterP[0*Kelvin]}..},
			(* in which case we are assuming linear connections between the profile points *)
			{
				initialTemp,
				Sequence@@Module[{fullProfile,flatRampProfile, updatedInitialTempDuration, updatedFlatRampProfile, paddedRampProfile, partitionedRampProfile, finalRampProfile},
					(* create the full profile *)
					fullProfile = Join[
						{
							(* check that initialTemp exists before making the zero point. *)
							Sequence@@If[NullQ[initialTemp],
								Nothing,
								{
									(* set the temperature at zero *)
									{0*Minute,initialTemp},
									(* check to make sure that the duration is not zero or null before making a second point *)
									If[NullQ[initialTempDuration] || MatchQ[initialTempDuration,EqualP[0*Minute]],
										Nothing,
										{initialTempDuration,initialTemp}
									]
								}
							]
						},
						(* check out what's going on with the profile compared to the 2 initial points *)
						Which[
							(* if our profile doesn't start at zero, but there are no initial points defined, throw an error *)
							!MatchQ[First[First[profile]],EqualP[0*Minute]] && NullQ[initialTemp],
							Message[Error::ProfileDoesNotStartAtZero];
							Return[$Failed],
							(* if there are initial parameters specified but the specified profile starts at zero, throw an error *)
							!NullQ[initialTemp] && !NullQ[initialTempDuration] && MatchQ[First[First[profile]],EqualP[0*Minute]],
							Message[Error::ProfileIsOverSpecified];
							Return[$Failed],
							True,
							profile
						]
					];

					(* create a flat list of the profile contents *)
					flatRampProfile = Flatten@MapThread[Function[{firstPoint, secondPoint},
						(*If the first and second point have the same temperature, it's a hold step*)
						If[MatchQ[Last[firstPoint], EqualP[Last[secondPoint]]],
							(*return the difference in time between the two points*)
							{First[secondPoint] - First[firstPoint]},
							(*otherwise they are different, so return a ramp rate (\[CapitalDelta]T/\[CapitalDelta]t) and the \new temperature (T2)*)
							{(Last[secondPoint] - Last[firstPoint])/(First[secondPoint] - First[firstPoint]), Last[secondPoint]}
						]
					],
						{Most[Rest[fullProfile]], Rest[Rest[fullProfile]]}
					];

					(* there may be a profile that starts with a hold time, so if that's the case we have to add that duration to the defined duration *)
					{updatedInitialTempDuration,updatedFlatRampProfile} = If[CompatibleUnitQ[First[flatRampProfile],Minute],
						initialTempDuration+First[flatRampProfile],Rest[flatRampProfile],
						initialTempDuration,flatRampProfile
					];

					(* next there's the case where the hold time after a ramp step is zero. *)
					paddedRampProfile = If[MatchQ[Partition[updatedFlatRampProfile,3],{{_?(CompatibleUnitQ[#,Kelvin/Minute]&),_?(CompatibleUnitQ[#,Kelvin]&),_?(CompatibleUnitQ[#,Minute]&)}...}],
						Return[{updatedInitialTempDuration,Partition[updatedFlatRampProfile,3]}],
						Flatten@SequenceReplace[flatProfile, {x_?(CompatibleUnitQ[#,Kelvin]&), y_?(CompatibleUnitQ[#, Kelvin/Minute] &)} :> {x, 0*Minute, y}]
					];

					(* now we can partitionRemainder the padded profile *)
					partitionedRampProfile = PartitionRemainder[paddedRampProfile,3];

					finalRampProfile = If[Length[Last[partitionedRampProfile]]==3,
						partitionedRampProfile,
						Join[Most[partitionedRampProfile],{Join[Last[partitionedRampProfile],{0*Minute}]}]
					];

					(* return the modified initialTempDuration and rampRateProfile *)
					{updatedInitialTempDuration,finalRampProfile}
				]
			},
			(* if we are given a ramp rate profile, that's great. *)
			{{GreaterP[0*Kelvin/Minute],GreaterP[0*Kelvin],GreaterEqualP[0*Minute]}..},
			{initialTemp,initialTempDuration,profile},
			(* setting a temperature in lieu of any initial conditions is allowed, but we will have to convert the profile to an initial temperature and null it out here. also todo: error check this in resolver *)
			GreaterP[0*Kelvin],
			{profile,0*Minute,Null},
			(* and finally, setting the profile to Isothermal which implies that we are keeping the initial temperature throughout the run *)
			Isothermal,
			{initialTemp,initialTempDuration,Null},
			(* we can also get an empty list if no profile was set. this is equivalent to an isothermal, but we should do some option resolution to take care of this possibility so it's not ambiguous *)
			{},
			{initialTemp,initialTempDuration,Null}
		]
	];

	(* flow and pressure profiles *)
	{initialColumnPressure,columnPressureProfile,initialColumnSetpointDuration,columnFlowRateProfile,initialColumnFlowRate} = Module[
		{pressureProfile,flowProfile,initialPressure,initialFlowRate,initialSetpointDuration},
		(* for each set point and profile inside the option, we need to transform that profile into a ramp rate profile *)
		{pressureProfile,flowProfile,initialPressure,initialFlowRate,initialSetpointDuration} = Lookup[myMethodPacket,{ColumnPressureProfile,ColumnFlowRateProfile,InitialColumnPressure,InitialColumnFlowRate,InitialColumnSetpointDuration}];
		(* check what kind of profile we are dealing with *)
		If[NullQ[pressureProfile],
			(* the pressure profile is null so we're dealing with a flow rate profile *)
			Switch[
				flowProfile,
				(* we may have a time/temperature profile *)
				{{GreaterEqualP[0*Minute],GreaterP[0*Milli*Liter/Minute]}..},
				(* in which case we are assuming linear connections between the profile points *)
				{
					initialPressure,
					pressureProfile,
					Sequence@@Module[{fullProfile,flatRampProfile, updatedInitialFlowDuration, updatedFlatRampProfile, paddedRampProfile, partitionedRampProfile, finalRampProfile},
						(* create the full profile *)
						fullProfile = Join[
							{
								(* check that initialFlowRate exists before making the zero point. *)
								Sequence@@If[NullQ[initialFlowRate],
									Nothing,
									{
										(* set the temperature at zero *)
										{0*Minute,initialFlowRate},
										(* check to make sure that the duration is not zero or null before making a second point *)
										If[NullQ[initialSetpointDuration] || MatchQ[initialSetpointDuration,EqualP[0*Minute]],
											Nothing,
											{initialSetpointDuration,initialFlowRate}
										]
									}
								]
							},

							(* check out what's going on with the profile compared to the 2 initial points *)
							Which[
								(* if our profile doesn't start at zero, but there are no initial points defined, throw an error *)
								!MatchQ[First[First[flowProfile]],EqualP[0*Minute]] && NullQ[initialFlowRate],
								Message[Error::ProfileDoesNotStartAtZero];
								Return[$Failed],
								(* if there are initial parameters specified but the specified profile starts at zero, throw an error *)
								!NullQ[initialFlowRate] && !NullQ[initialSetpointDuration] && MatchQ[First[First[flowProfile]],EqualP[0*Minute]],
								Message[Error::ProfileIsOverSpecified];
								Return[$Failed],
								True,
								flowProfile
							]
						];

						(* create a flat list of the profile contents *)
						flatRampProfile = Flatten@MapThread[Function[{firstPoint, secondPoint},
							(*If the first and second point have the same flow rate, it's a hold step*)
							If[MatchQ[Last[firstPoint], EqualP[Last[secondPoint]]],
								(*return the difference in time between the two points*)
								{First[secondPoint] - First[firstPoint]},
								(*otherwise they are different, so return a ramp rate (\[CapitalDelta]F/\[CapitalDelta]t) and the \new flow rate (F2)*)
								{(Last[secondPoint] - Last[firstPoint])/(First[secondPoint] - First[firstPoint]), Last[secondPoint]}
							]
						],
							{Most[Rest[fullProfile]], Rest[Rest[fullProfile]]}
						];

						(* there may be a profile that starts with a hold time, so if that's the case we have to add that duration to the defined duration *)
						{updatedInitialFlowDuration,updatedFlatRampProfile} = If[CompatibleUnitQ[First[flatRampProfile],Minute],
							initialSetpointDuration+First[flatRampProfile],Rest[flatRampProfile],
							initialSetpointDuration,flatRampProfile
						];

						(* next there's the case where the hold time after a ramp step is zero. *)
						paddedRampProfile = If[MatchQ[Partition[updatedFlatRampProfile,3],{{_?(CompatibleUnitQ[#,Milli*Liter/Minute/Minute]&),_?(CompatibleUnitQ[#,Milli*Liter/Minute]&),_?(CompatibleUnitQ[#,Minute]&)}...}],
							Return[{updatedInitialFlowDuration,Partition[updatedFlatRampProfile,3]}],
							Flatten@SequenceReplace[flatProfile, {x_?(CompatibleUnitQ[#,Milli*Liter/Minute]&), y_?(CompatibleUnitQ[#, Milli*Liter/Minute/Minute] &)} :> {x, 0*Minute, y}]
						];

						(* now we can partitionRemainder the padded profile *)
						partitionedRampProfile = PartitionRemainder[paddedRampProfile,3];

						finalRampProfile = If[Length[Last[partitionedRampProfile]]==3,
							partitionedRampProfile,
							Join[Most[partitionedRampProfile],{Join[Last[partitionedRampProfile],{0*Minute}]}]
						];

						(* return the modified initialDuration and rampRateProfile *)
						{updatedInitialFlowDuration,finalRampProfile}
					],
					initialFlowRate
				},
				(* if we are given a ramp rate profile, that's great. *)
				{{GreaterP[0*Milli*Liter/Minute/Minute],GreaterP[0*Milli*Liter/Minute],GreaterEqualP[0*Minute]}..},
				{initialPressure, pressureProfile, initialSetpointDuration, flowProfile, initialFlowRate},
				(* setting a temperature in lieu of any initial conditions is allowed, but we will have to convert the profile to an initial flow rate and null it out here. also todo: error check this in resolver *)
				GreaterP[0*Milli*Liter/Minute],
				{initialPressure, pressureProfile, 0*Minute, Null, flowProfile},
				(* and finally, setting the profile to Isothermal which implies that we are keeping the initial flow rate throughout the run *)
				ConstantFlowRate,
				{initialPressure, pressureProfile, initialSetpointDuration, Null, initialFlowRate},
				(* we can also get an empty list if no profile was set. this is equivalent to an ConstantFlowRate, but we should do some option resolution to take care of this possibility so it's not ambiguous *)
				{},
				{initialPressure, pressureProfile, initialSetpointDuration, Null, initialFlowRate}
			],
			(* otherwise we're dealing with pressure *)
			Switch[
				pressureProfile,
				(* we may have a time/temperature profile *)
				{{GreaterEqualP[0*Minute],GreaterP[0*PSI]}..},
				(* in which case we are assuming linear connections between the profile points *)
				{
					initialPressure,
					Sequence@@Module[{fullProfile,flatRampProfile, updatedInitialPressureDuration, updatedFlatRampProfile, paddedRampProfile, partitionedRampProfile, finalRampProfile},
						(* create the full profile *)
						fullProfile = Join[
							{
								(* check that initialFlowRate exists before making the zero point. *)
								Sequence@@If[NullQ[initialPressure],
									Nothing,
									{
										(* set the temperature at zero *)
										{0*Minute,initialPressure},
										(* check to make sure that the duration is not zero or null before making a second point *)
										If[NullQ[initialSetpointDuration] || MatchQ[initialSetpointDuration,EqualP[0*Minute]],
											Nothing,
											{initialSetpointDuration,initialPressure}
										]
									}
								]
							},
							(* check out what's going on with the profile compared to the 2 initial points *)
							Which[
								(* if our profile doesn't start at zero, but there are no initial points defined, throw an error *)
								!MatchQ[First[First[pressureProfile]],EqualP[0*Minute]] && NullQ[initialPressure],
								Message[Error::ProfileDoesNotStartAtZero];
								Return[$Failed],
								(* if there are initial parameters specified but the specified profile starts at zero, throw an error *)
								!NullQ[initialPressure] && !NullQ[initialSetpointDuration] && MatchQ[First[First[pressureProfile]],EqualP[0*Minute]],
								Message[Error::ProfileIsOverSpecified];
								Return[$Failed],
								True,
								pressureProfile
							]
						];

						(* create a flat list of the profile contents *)
						flatRampProfile = Flatten@MapThread[Function[{firstPoint, secondPoint},
							(*If the first and second point have the same pressure, it's a hold step*)
							If[MatchQ[Last[firstPoint], EqualP[Last[secondPoint]]],
								(*return the difference in time between the two points*)
								{First[secondPoint] - First[firstPoint]},
								(*otherwise they are different, so return a ramp rate (\[CapitalDelta]P/\[CapitalDelta]t) and the \new pressure (P2)*)
								{(Last[secondPoint] - Last[firstPoint])/(First[secondPoint] - First[firstPoint]), Last[secondPoint]}
							]
						],
							{Most[Rest[fullProfile]], Rest[Rest[fullProfile]]}
						];

						(* there may be a profile that starts with a hold time, so if that's the case we have to add that duration to the defined duration *)
						{updatedInitialPressureDuration,updatedFlatRampProfile} = If[CompatibleUnitQ[First[flatRampProfile],Minute],
							initialSetpointDuration+First[flatRampProfile],Rest[flatRampProfile],
							initialSetpointDuration,flatRampProfile
						];

						(* next there's the case where the hold time after a ramp step is zero. *)
						paddedRampProfile = If[MatchQ[Partition[updatedFlatRampProfile,3],{{_?(CompatibleUnitQ[#,PSI/Minute]&),_?(CompatibleUnitQ[#,PSI]&),_?(CompatibleUnitQ[#,Minute]&)}...}],
							Return[{updatedInitialPressureDuration,Partition[updatedFlatRampProfile,3]}],
							Flatten@SequenceReplace[flatProfile, {x_?(CompatibleUnitQ[#,PSI]&), y_?(CompatibleUnitQ[#, PSI/Minute] &)} :> {x, 0*Minute, y}]
						];

						(* now we can partitionRemainder the padded profile *)
						partitionedRampProfile = PartitionRemainder[paddedRampProfile,3];

						finalRampProfile = If[Length[Last[partitionedRampProfile]]==3,
							partitionedRampProfile,
							Join[Most[partitionedRampProfile],{Join[Last[partitionedRampProfile],{0*Minute}]}]
						];

						(* return the modified initialPressureDuration and rampRateProfile *)
						{finalRampProfile,updatedInitialPressureDuration}
					],
					flowProfile,
					initialFlowRate
				},
				(* if we are given a ramp rate profile, that's great. *)
				{{GreaterP[0*PSI/Minute],GreaterP[0*PSI],GreaterEqualP[0*Minute]}..},
				{initialPressure, pressureProfile, initialSetpointDuration, flowProfile, initialFlowRate},
				(* setting a temperature in lieu of any initial conditions is allowed, but we will have to convert the profile to an initial pressure and null it out here. also todo: error check this in resolver *)
				GreaterP[0*PSI],
				{pressureProfile, Null, 0*Minute, flowProfile, initialFlowRate},
				(* and finally, setting the profile to ConstantPressure which implies that we are keeping the initial pressure throughout the run *)
				ConstantPressure,
				{initialPressure, Null, initialSetpointDuration, flowProfile, initialFlowRate},
				(* we can also get an empty list if no profile was set. this is equivalent to an ConstantPressure, but we should do some option resolution to take care of this possibility so it's not ambiguous *)
				{},
				{initialPressure, Null, initialSetpointDuration, flowProfile, initialFlowRate}
			]
		]
	];


	(* Convert profiles into time vs. temperature data *)

	(* do the oven profile first *)
	columnOvenTemperatureTimeProfile=rampProfileConversion[initialOvenTemperature,initialOvenTemperatureDuration,ovenTemperatureProfile];

	methodTime = First[Last[columnOvenTemperatureTimeProfile]];

	(* then we can do all the rest of the profiles *)
	inletTemperatureTimeProfile=rampProfileConversion[initialInletTemperature,initialInletTemperatureDuration,inletTemperatureProfile,methodTime];

	(* Column pressure profile or flow rate profile *)
	{
		initialColumnAverageVelocity, initialColumnHoldupTime, initialColumnSetpointDuration, columnPressureRampProfile, columnFlowRateRampProfile
	} = Lookup[myMethodPacket,{
		InitialColumnAverageVelocity, InitialColumnResidenceTime, InitialColumnSetpointDuration, ColumnPressureProfile, ColumnFlowRateProfile
	}];

	initialColumnSetpoint=FirstCase[{initialColumnFlowRate,initialColumnPressure,initialColumnAverageVelocity,initialColumnHoldupTime}, Except[Null]];

	(* resolve GC column mode *)
	gcColumnMode = Module[
		{profile, resolvedMode},

		(* pick the profile *)
		profile = FirstCase[{columnPressureRampProfile, columnFlowRateRampProfile},Except[Null]];

		(* if the profile is ConstantPressure/ConstantFlowRate return immediately *)
		resolvedMode = If[MatchQ[profile,_Symbol],
			profile,
			Which[
				CompatibleUnitQ[First[profile][[2]],PSI],
				PressureProfile,
				CompatibleUnitQ[First[profile][[2]],Liter/Minute],
				FlowRateProfile,
				True,
				$Failed
			]
		]
	];

	(* If GCColumnMode is RampedPressure or RampedFlowRate, do the profile synthesis and manipulation, otherwise just turn the initial setpoint into a constant pressure or flow rate profile as indicated by the mode. *)

	initialColumnSetpoint = Switch[
		gcColumnMode,
		(FlowRateProfile | ConstantFlowRate),
		Which[
			!NullQ[initialColumnFlowRate],
			initialColumnFlowRate,
			CompatibleUnitQ[initialColumnSetpoint, PSI],
			Experiment`Private`convertColumnPressureToFlowRate[carrierGas,First[columnDiameters],First[columnLengths],initialColumnSetpoint, Last[Last[columnOvenTemperatureTimeProfile]],outletPressure, referencePressure, referenceTemperature],
			CompatibleUnitQ[initialColumnSetpoint, Meter/Minute],
			Experiment`Private`convertColumnVelocityToFlowRate[carrierGas,First[columnDiameters],First[columnLengths],initialColumnSetpoint, Last[Last[columnOvenTemperatureTimeProfile]],outletPressure, referencePressure, referenceTemperature],
			CompatibleUnitQ[initialColumnSetpoint, Minute],
			Experiment`Private`convertColumnResidenceTimeToFlowRate[carrierGas,First[columnDiameters],First[columnLengths],initialColumnSetpoint, Last[Last[columnOvenTemperatureTimeProfile]],outletPressure, referencePressure, referenceTemperature]
		],
		(PressureProfile | ConstantPressure),
		Which[
			!NullQ[initialColumnPressure],
			initialColumnPressure,
			CompatibleUnitQ[initialColumnSetpoint, Liter/Minute],
			Experiment`Private`convertColumnFlowRateToPressure[carrierGas,First[columnDiameters],First[columnLengths],initialColumnSetpoint, Last[Last[columnOvenTemperatureTimeProfile]],outletPressure, referencePressure, referenceTemperature],
			CompatibleUnitQ[initialColumnSetpoint, Meter/Minute],
			Experiment`Private`convertColumnVelocityToPressure[carrierGas,First[columnDiameters],First[columnLengths],initialColumnSetpoint, Last[Last[columnOvenTemperatureTimeProfile]],outletPressure, referencePressure, referenceTemperature],
			CompatibleUnitQ[initialColumnSetpoint, Minute],
			Experiment`Private`convertColumnResidenceTimeToPressure[carrierGas,First[columnDiameters],First[columnLengths],initialColumnSetpoint, Last[Last[columnOvenTemperatureTimeProfile]],outletPressure, referencePressure, referenceTemperature]
		]
	];

	(* create the column flow/pressure profile *)
	columnTimeProfile=Switch[
		gcColumnMode,
		(FlowRateProfile | ConstantFlowRate),
		rampProfileConversion[initialColumnSetpoint,initialColumnSetpointDuration,columnFlowRateProfile,methodTime],
		(PressureProfile | ConstantPressure),
		rampProfileConversion[initialInletTemperature,initialInletTemperatureDuration,columnPressureProfile,methodTime]
	];

	(* Interpolate the oven temperature and columnTimeProfile to prepare for mirror creation *)
	interpolatedOvenProfile=Interpolation[columnOvenTemperatureTimeProfile,InterpolationOrder->1];
	interpolatedColumnProfile=Interpolation[columnTimeProfile,InterpolationOrder->1];

	(* If the columnProfile is in pressure, identify it as such and convert to flow rate. Also create the mirrored profile. *)
	{interpolatedColumnFlowRateProfile, interpolatedColumnPressureProfile, columnFlowRateTimeProfileInitial, columnPressureTimeProfileInitial} = Which[
		CompatibleUnitQ[Last[First[columnTimeProfile]],PSI],
		Module[{flowRateProfile, pressureProfile, flowRateTimeProfile, pressureTimeProfile},
			pressureProfile[timeVar_]:=interpolatedColumnProfile[timeVar];
			flowRateProfile[timeVar_]:=Experiment`Private`convertColumnPressureToFlowRate[carrierGas,First@columnDiameters,First@columnLengths,pressureProfile[timeVar], interpolatedOvenProfile[timeVar],outletPressure, referencePressure, referenceTemperature];
			pressureTimeProfile=Table[{time,pressureProfile[time]},{time,0*Minute,First[Last[columnOvenTemperatureTimeProfile]],First[Last[columnOvenTemperatureTimeProfile]]/100}];
			flowRateTimeProfile=Table[{time,Experiment`Private`convertColumnPressureToFlowRate[carrierGas,First@columnDiameters,First@columnLengths,pressureProfile[time], interpolatedOvenProfile[time],outletPressure, referencePressure, referenceTemperature]},{time,0*Minute,First[Last[columnOvenTemperatureTimeProfile]],First[Last[columnOvenTemperatureTimeProfile]]/100}];

			(*return the results*)
			{flowRateProfile, pressureProfile, flowRateTimeProfile, pressureTimeProfile}
		],
		(* If the columnProfile is in flow rate, identify it as such and convert to pressure. Also create the mirrored profile. TODO: Add if statements *)
		CompatibleUnitQ[Last[First[columnTimeProfile]],Liter/Minute],
		Module[
			{flowRateProfile, pressureProfile, flowRateTimeProfile, pressureTimeProfile},
			flowRateProfile[timeVar_]:=interpolatedColumnProfile[timeVar];
			pressureProfile[timeVar_]:=Experiment`Private`convertColumnFlowRateToPressure[carrierGas,First@columnDiameters,First@columnLengths,flowRateProfile[timeVar], interpolatedOvenProfile[timeVar],outletPressure, referencePressure, referenceTemperature];
			flowRateTimeProfile=Table[{time,flowRateProfile[time]},{time,0*Minute,First[Last[columnOvenTemperatureTimeProfile]],First[Last[columnOvenTemperatureTimeProfile]]/100}];
			pressureTimeProfile=Table[{time,Experiment`Private`convertColumnFlowRateToPressure[carrierGas,First@columnDiameters,First@columnLengths,flowRateProfile[time], interpolatedOvenProfile[time],outletPressure, referencePressure, referenceTemperature]},{time,0*Minute,First[Last[columnOvenTemperatureTimeProfile]],First[Last[columnOvenTemperatureTimeProfile]]/100}];

			(*return the results*)
			{flowRateProfile, pressureProfile, flowRateTimeProfile, pressureTimeProfile}
		]
	];

	(* this is all well and good, but if we have an initial pressure, this will factor into the pressure and flowrate so we need to re-do all of this *)
	{initialInletPressure,initialInletTime} = Lookup[myMethodPacket,{InitialInletPressure,InitialInletTime}];
	{initialInletPressure,initialInletTime} = {20*PSI,2*Minute};

	(* do a final conversion *)
	{columnFlowRateTimeProfile, columnPressureTimeProfile} = If[!NullQ[initialInletPressure],
		Module[{piecewisePressure,piecewiseFlowRate, pressureTimeProfile, flowRateTimeProfile},
			(* do the piecewise myself *)
			pressureTimeProfile=Table[{time,If[time<=initialInletTime,initialInletPressure,interpolatedColumnPressureProfile[time]]},{time,0*Minute,First[Last[columnOvenTemperatureTimeProfile]],First[Last[columnOvenTemperatureTimeProfile]]/100}];
			flowRateTimeProfile=Table[{time,If[time<=initialInletTime,Experiment`Private`convertColumnPressureToFlowRate[carrierGas,First@columnDiameters,First@columnLengths,initialInletPressure, interpolatedOvenProfile[time],outletPressure, referencePressure, referenceTemperature],interpolatedColumnFlowRateProfile[time]]},{time,0*Minute,First[Last[columnOvenTemperatureTimeProfile]],First[Last[columnOvenTemperatureTimeProfile]]/100}];

			(* return result *)
			{flowRateTimeProfile, pressureTimeProfile}
		],
		{columnFlowRateTimeProfileInitial, columnPressureTimeProfileInitial}
	];

	(* Split flow profiles *)
	(* Split ratio/flow rate. TODO: DOES THE SPLIT RATIO STILL APPLY IN PULSED MODE??? *)
	splitRatio=Lookup[myMethodPacket,SplitRatio];
	splitVentFlowRate=Lookup[myMethodPacket,SplitVentFlowRate];

	(* Splitless time conditions *)
	splitlessPurgeFlowRate=Lookup[myMethodPacket,SplitVentFlowRate];
	splitlessTime=Lookup[myMethodPacket,SplitlessTime];
	gasSaverFlowRate=Lookup[myMethodPacket,GasSaverFlowRate];
	gasSaverActivationTime=Lookup[myMethodPacket,GasSaverActivationTime];

	(* Include a cumulative liner volumes turned over? *)

	(* Check to see what actually needs to be plotted, then generate the plot call *)

	(* plotting *)
	temperaturePlot = EmeraldListLinePlot[
		{columnOvenTemperatureTimeProfile,inletTemperatureTimeProfile},
		PlotLabel->"Column Oven and Inlet Temperature",
		Legend->{"Column Oven Temperature","Inlet Temperature"},
		Boxes->True,
		PassOptions[PlotGasChromatographyMethod,EmeraldListLinePlot,ops]
	];



	pressureFlowPlot = EmeraldListLinePlot[
		columnFlowRateTimeProfile,
		PlotRange -> {All, {0.8* Min[Last /@ columnFlowRateTimeProfile], 1.2*Max[Last /@ columnFlowRateTimeProfile]}},
		SecondYCoordinates->columnPressureTimeProfile,
		SecondYRange -> {All, {0.8* Min[Last /@ columnPressureTimeProfile], 1.2*Max[Last /@ columnPressureTimeProfile]}},
		PlotLabel->"Column Flow Rate and Head Pressure",
		Boxes->False,
		PassOptions[PlotGasChromatographyMethod,EmeraldListLinePlot,ops]
	];

	(* Plot a multi-pane table: in top pane, temperature profiles vs. time, in bottom pane, inlet pressure and column flow profiles (left and right x-axes) *)
	TableForm[
		{
			PopupMenu[Dynamic[plotOption], {temperaturePlot -> "Column and inlet temperatures", pressureFlowPlot -> "Column flow and pressure"}],
			Dynamic[plotOption]
		}
	]
];
