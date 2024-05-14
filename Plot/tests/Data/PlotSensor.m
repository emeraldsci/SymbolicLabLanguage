(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSensor*)


DefineTests[PlotSensor,
	{
		Example[{Basic, "Plot sensor data object:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:O81aEB4zD4wj"]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot sensor data info packet:"},
			PlotSensor[Download[Object[Data, RelativeHumidity, "id:O81aEB4zD4wj"]]],
			_?ValidGraphicsQ
		],
		Example[{Messages, "InvalidDataObject", "Plot data object that does not exist:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:O81aEBzD4wj"]],
			Null,
			Messages:>PlotSensor::InvalidDataObject
		],
		Example[{Basic, "Plot a list of data points:"},
			PlotSensor[{{DateObject[{2015,7,4},TimeObject[{12,11,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[19.197198400830104`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,12,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[19.56625873592334`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,13,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[18.93673512985626`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,14,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[18.405627613147377`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,15,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[17.975481429486983`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,16,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[17.749803155613883`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,17,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[17.477462080751977`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,18,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[17.25093539231544`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,19,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[17.08719138157293`,"Celsius"]},{DateObject[{2015,7,4},TimeObject[{12,20,19.`},TimeZone->-7.`],TimeZone->-7.`],Quantity[16.925144199957277`,"Celsius"]}}],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot a list of data packets:"},
			PlotSensor[Download[{Object[Data, RelativeHumidity, "id:O81aEB4zD4wj"],Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"]}]],
			{_?ValidGraphicsQ,_?ValidGraphicsQ }
		],
		Example[{Basic, "Plot a list of data object:"},
			PlotSensor[{Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"], Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"]}],
			{_?ValidGraphicsQ,_?ValidGraphicsQ }
		],
		Example[{Options,PlotRange,"Set the plot range in {{xmin,xmax},{ymin,ymax}} format:"},
			PlotSensor[Download[Object[Data, RelativeHumidity, "id:O81aEB4zD4wj"]],PlotRange->{All,{20,25}}],
			_?ValidGraphicsQ
		],
		Example[{Options,yAxisLabel, "Specify the yAxisLabel (option):"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"], yAxisLabel->"taco"],
			_?ValidGraphicsQ
		],
		Example[{Options,Frame, "Specify the if the plot is framed (option):"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"], Frame->True],
			_?ValidGraphicsQ
		],
		Example[{Options,FrameStyle, "Specify the style of each frame, using the {{left,right},{bottom,top}} format:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"],Frame->True,FrameStyle->{{Red,Blue},{Green,Purple}}],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabel, "Specify a label for the plot:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"],PlotLabel->"Relative Humidity in the ECL"],
			ValidGraphicsP[]
		],
		Example[{Options,LabelStyle, "Change the style of all labels in the plot:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"],PlotLabel->"Relative Humidity in the ECL",LabelStyle->{Red,20,FontFamily->"Helvetica"}],
			ValidGraphicsP[]
		],
		Example[{Options,Joined, "Specify if the date points are joined (option):"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"], Joined->True],
			_?ValidGraphicsQ
		],
		Example[{Options,ImageSize, "Specify the image size (option):"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"], ImageSize -> 500],
			_?ValidGraphicsQ
		],
		Example[{Options,Zoomable,"Make the output Zoomable:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"], Zoomable->True],
			ValidGraphicsP[]
		],
		Example[{Options,GridLines,"Disable Gridlines in the plot:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"],GridLines->None],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Construct a plot legend by providing a list of labels for each dataset:"},
			PlotSensor[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"],Legend->{"Wetness"}],
			ValidGraphicsP[]
		],
		Test["Plot a list of list of datapoints:",
			PlotSensor[{Lookup[Download[Object[Data, RelativeHumidity, "id:4pO6dMWK1Wzo"]],RelativeHumidityLog],Lookup[Download[Object[Data, RelativeHumidity, "id:O81aEB4zD4wj"]],RelativeHumidityLog]}],
			{_?ValidGraphicsQ,_?ValidGraphicsQ}
		]
	},
	Skip->"File Server"
];
