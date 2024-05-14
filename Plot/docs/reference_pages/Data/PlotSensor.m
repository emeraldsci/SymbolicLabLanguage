(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSensor*)


(* we are computing the pattern before defineUsage to get a nice pattern from SensorDataTypeP*)
With[{spelledOutSensorDataType = List@@sensorDataTypeP},
	DefineUsage[PlotSensor,
		{
			BasicDefinitions -> {
				{
					Definition->{"PlotSensor[SensorDataObject]", "plot"},
					Description->"plot sensor data from 'SensorDataObject'.",
					Inputs:>{
						{
							InputName->"SensorDataObject",
							Description->"Sensor Data object.",
							Widget->Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[spelledOutSensorDataType]],
								"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[spelledOutSensorDataType]]]
							]
						}
					},
					Outputs:>{
						{
							OutputName->"plot",
							Description->"The plot of the sensor data.",
							Pattern:>ValidGraphicsP[]
						}
					}
				},
				{
					Definition->{"PlotSensor[data]", "plot"},
					Description->"plot sensor data from raw 'data'.",
					Inputs:>{
						{
							InputName->"data",
							Description->"A list of {{date,y}..} coordinates.",
							Widget->Alternatives[
								"Single Object"->Widget[Type->Expression,Pattern:>Alternatives[DateCoordinateP,{{_?DateObjectQ, _?UnitsQ}..}],Size->Paragraph],
								"Multiple Objects"->Adder[Widget[Type->Expression,Pattern:>Alternatives[DateCoordinateP,{{_?DateObjectQ, _?UnitsQ}..}],Size->Paragraph]]
							]
						}
					},
					Outputs:>{
						{
							OutputName->"plot",
							Description->"The plot of the sensor data.",
							Pattern:>ValidGraphicsP[]
						}
					}
				}
			},
			SeeAlso -> {
				"RecordSensor",
				"DateListPlot"
			},
			Author -> {"scicomp", "brad", "gil.sharon"},
			Preview->True
		}
	]
];