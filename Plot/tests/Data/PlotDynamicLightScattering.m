(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDynamicLightScattering*)


DefineTests[PlotDynamicLightScattering,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given a DynamicLightScattering data object, creates a plot for the MassDistribution if AssayType is SizingPolydispersity, ZAverageDiameters if the AssayType is IsothermalStability, KirkwoodBuffIntegral if the AssayType is G22, and PolydispersityIndicies if the AssayType is B22kD:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"]
			],
			ValidGraphicsP[]
		],
		(* -- Additional -- *)
		Example[{Basic,"Return a dynamic figure when Output->Preview:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				Output->Preview
			],
			ValidGraphicsP[]
		],
		Example[{Basic,"Return a list of resolved options when Output->Option:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				Output->Options
			],
			{_Rule..}
		],
		Example[{Basic,"Return a list of resolved options when Output->Tests:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				Output->Tests
			],
			{}
		],
		Example[{Additional,"Plot dynamic light scattering data from Object[Data, MeltingCurve] if it contains dynamic light scattering data:"},
			PlotDynamicLightScattering[
				Object[Data, MeltingCurve, "Good melting curve data for PlotDynamicLightScattering tests"]
			],
			ValidGraphicsP[]
		],
		Example[{Additional,"Plot dynamic light scattering data for multiple Object[Data, MeltingCurve] to create a slideview for each data object:"},
			PlotDynamicLightScattering[
				{
					Object[Data, MeltingCurve, "Good melting curve data for PlotDynamicLightScattering tests"],
					Object[Data, MeltingCurve, "Good melting curve data for PlotDynamicLightScattering tests"]
				}
			],
			_SlideView
		],
		Example[{Additional,"Plot dynamic light scattering data for Object[Data, MeltingCurve] and use secondary data to plot additional information:"},
			PlotDynamicLightScattering[
				Object[Data, MeltingCurve, "Good melting curve data for PlotDynamicLightScattering tests"],
				SecondaryData -> {FinalMassDistribution}
			],
			ValidGraphicsP[]
		],
		Example[{Messages,"NoDynamicLightScatteringData","Plotting dynamic light scattering data from Object[Data, MeltingCurve] that contains no dynamic light scattering data will throw an error:"},
			PlotDynamicLightScattering[
				Object[Data, MeltingCurve, "Bad melting curve data for PlotDynamicLightScattering tests"]
			],
			$Failed,
			Messages:>{Message[Error::NoDynamicLightScatteringData]}
		],
		(* -- OPTIONS -- *)
		Example[{Options,PrimaryData,"Set the PrimaryData Option:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				PrimaryData->IntensityDistribution
			],
			ValidGraphicsP[]
		],
		Example[{Options,SecondaryData,"Set the SecondaryData Option:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				SecondaryData->{IntensityDistribution}
			],
			ValidGraphicsP[]
		],
		Example[{Options, Display, "Set the Display mode for the output plots:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				Display -> {}
			],
			ValidGraphicsP[]
		],
		Example[{Options, ImageSize, "Set the image size for the output plots:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				ImageSize -> 800
			],
			ValidGraphicsP[]
		],
		Example[{Options, IncludeReplicates, "Set the image size for the output plots:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				IncludeReplicates -> True
			],
			ValidGraphicsP[]
		],
		Example[{Options, TargetUnits, "Set TargetUnits of x and y axis:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				TargetUnits -> {Meter, Automatic}
			],
			ValidGraphicsP[]
		],
		Example[{Options, Zoomable, "Set if the resulting plots are zoomable:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				Zoomable -> True
			],
			ValidGraphicsP[]
		],
		Example[{Options, OptionFunctions, "Set OptionFunctions for this plot:"},
			PlotDynamicLightScattering[
				Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
				OptionFunctions -> {}
			],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Specify a legend:"},
			PlotDynamicLightScattering[
				{Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],Object[Data, DynamicLightScattering, "Fake replicate data 1 for PlotDynamicLightScattering tests"]},
				Legend -> {"Test1","Test2"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,LegendPlacement,"Specify a where to put the legned:"},
			PlotDynamicLightScattering[
				{Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],Object[Data, DynamicLightScattering, "Fake replicate data 1 for PlotDynamicLightScattering tests"]},
				Legend -> {"Test1","Test2"},
				LegendPlacement->Right
			],
			ValidGraphicsP[]
		],
		Example[{Options,Boxes,"Specify boxes are desired for this plot:"},
			PlotDynamicLightScattering[
				{Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"]},
				Boxes -> True
			],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Specify FrameLabels:"},
			PlotDynamicLightScattering[
				{Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"]},
				FrameLabel -> {"Test1","Test2"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabel,"Specify FrameLabels:"},
			PlotDynamicLightScattering[
				{Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"]},
				PlotLabel -> {"Test1"}
			],
			ValidGraphicsP[]
		]
	},

	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
					Object[Data, DynamicLightScattering, "Fake replicate data 1 for PlotDynamicLightScattering tests"],
					Object[Data, MeltingCurve, "Good melting curve data for PlotDynamicLightScattering tests"],
					Object[Data, MeltingCurve, "Bad melting curve data for PlotDynamicLightScattering tests"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					massDistribution,dataObject1,dataObject2, initialMassDistribution,
					finalMassDistribution, dataObject3

				},

				(* Set a variable to a QuantityArray *)
				massDistribution=StructuredArray[QuantityArray,List[256,2],StructuredArray`StructuredData[QuantityArray,List[List[0.0160934161394835`,0.`],List[0.0173912383615971`,0.`],List[0.0187937207520008`,0.`],List[0.0203093029558659`,0.`],List[0.021947106346488`,0.`],List[0.023716988041997`,0.`],List[0.025629598647356`,0.`],List[0.0276964493095875`,0.`],List[0.0299299750477076`,0.`],List[0.0323436185717583`,0.`],List[0.0349519066512585`,0.`],List[0.0377705357968807`,0.`],List[0.0408164672553539`,0.`],List[0.0441080294549465`,0.`],List[0.047665037214756`,0.`],List[0.0515088923275471`,0.`],List[0.0556627251207829`,0.`],List[0.0601515360176563`,0.`],List[0.0650023445487022`,0.`],List[0.0702443271875381`,0.`],List[0.0759090483188629`,0.`],List[0.0820305794477463`,0.`],List[0.0886457785964012`,0.`],List[0.0957944467663765`,0.`],List[0.103519603610039`,0.`],List[0.111867740750313`,0.`],List[0.120889090001583`,0.`],List[0.130637958645821`,0.`],List[0.141173005104065`,0.`],List[0.152557626366615`,0.`],List[0.164860337972641`,0.`],List[0.178155183792114`,0.`],List[0.192522153258324`,0.`],List[0.208047732710838`,0.`],List[0.224825337529182`,0.`],List[0.242955937981606`,0.`],List[0.26254865527153`,0.`],List[0.283721357584`,0.`],List[0.306601524353027`,0.`],List[0.331326812505722`,0.`],List[0.358045995235443`,0.`],List[0.386919915676117`,0.`],List[0.418122321367264`,0.`],List[0.451840996742249`,0.`],List[0.488278836011887`,0.`],List[0.527655124664307`,0.`],List[0.570206820964813`,0.`],List[0.616190075874329`,0.`],List[0.665881514549255`,0.`],List[0.719580233097076`,0.`],List[0.777609348297119`,0.`],List[0.840318143367767`,0.`],List[0.908083975315094`,0.`],List[0.981314659118652`,0.`],List[1.06045091152191`,0.`],List[1.14596879482269`,0.`],List[1.23838329315186`,0.`],List[1.33825027942657`,0.`],List[1.44617092609406`,0.`],List[1.56279444694519`,0.`],List[1.68882298469543`,0.`],List[1.82501482963562`,0.`],List[1.9721896648407`,0.`],List[2.13123297691345`,0.`],List[2.30310225486755`,0.`],List[2.48883128166199`,0.`],List[2.68953824043274`,0.`],List[2.90643095970154`,0.`],List[3.14081430435181`,0.`],List[3.39409923553467`,0.`],List[3.66780972480774`,0.`],List[3.96359300613403`,0.`],List[4.2832293510437`,0.`],List[4.62864208221436`,0.`],List[5.0019097328186`,0.`],List[5.4052791595459`,0.`],List[5.84117746353149`,0.`],List[6.31222772598267`,0.`],List[6.82126474380493`,0.0199280381202698`],List[7.3713526725769`,0.061849020421505`],List[7.96580076217651`,0.0945853888988495`],List[8.60818767547607`,0.111192055046558`],List[9.30237770080566`,0.114381432533264`],List[10.0525503158569`,0.108674950897694`],List[10.8632183074951`,0.0979482680559158`],List[11.7392616271973`,0.084975078701973`],List[12.6859512329102`,0.0715588927268982`],List[13.7089853286743`,0.0587795414030552`],List[14.8145189285278`,0.0472172424197197`],List[16.0092067718506`,0.0371246710419655`],List[17.3002395629883`,0.0285504292696714`],List[18.6953830718994`,0.0214237906038761`],List[20.2030353546143`,0.01561130117625`],List[21.8322696685791`,0.010953695513308`],List[23.5928916931152`,0.00728976866230369`],List[25.4954929351807`,0.00447273021563888`],List[27.5515270233154`,0.00238390057347715`],List[29.7733669281006`,0.000948399712797254`],List[32.1743812561035`,0.00015139058814384`],List[34.7690238952637`,0.`],List[37.5729026794434`,0.`],List[40.602897644043`,0.`],List[43.8772392272949`,0.`],List[47.4156303405762`,0.`],List[51.239372253418`,0.`],List[55.3714714050293`,0.`],List[59.8367958068848`,0.`],List[64.6622161865234`,0.`],List[69.8767776489258`,0.`],List[75.5118560791016`,0.`],List[81.6013641357422`,0.`],List[88.1819458007813`,0.`],List[95.2932052612305`,0.`],List[102.97794342041`,0.`],List[111.28239440918`,0.`],List[120.256546020508`,0.`],List[129.954406738281`,0.`],List[140.434326171875`,0.`],List[151.759368896484`,0.`],List[163.997711181641`,0.`],List[177.222991943359`,0.`],List[191.514785766602`,0.`],List[206.959121704102`,0.`],List[223.648941040039`,0.`],List[241.684677124023`,0.`],List[261.174865722656`,0.`],List[282.23681640625`,0.`],List[304.997253417969`,0.`],List[329.593139648438`,0.`],List[356.172546386719`,0.`],List[384.895385742188`,0.`],List[415.934539794922`,0.`],List[449.476745605469`,0.`],List[485.723937988281`,0.`],List[524.894165039063`,0.`],List[567.223266601563`,0.`],List[612.965881347656`,0.`],List[662.397338867188`,0.`],List[715.815063476563`,0.`],List[773.540588378906`,0.`],List[835.921264648438`,0.`],List[903.332458496094`,0.`],List[976.179992675781`,0.`],List[1054.90209960938`,0.`],List[1139.97265625`,0.`],List[1231.90344238281`,0.`],List[1331.24792480469`,0.`],List[1438.60388183594`,0.`],List[1554.61730957031`,0.`],List[1679.986328125`,0.`],List[1815.46557617188`,0.`],List[1961.87023925781`,0.`],List[2120.08154296875`,0.`],List[2291.05126953125`,0.`],List[2475.80859375`,0.`],List[2675.46533203125`,0.`],List[2891.22314453125`,0.`],List[3124.38012695313`,0.`],List[3376.33959960938`,0.`],List[3648.61791992188`,0.`],List[3942.85375976563`,0.`],List[4260.8173828125`,0.`],List[4604.4228515625`,0.`],List[4975.7373046875`,0.`],List[5376.99609375`,0.`],List[5810.61376953125`,0.`],List[6279.19921875`,0.`],List[6785.57275390625`,0.`],List[7332.7822265625`,0.`],List[7924.1201171875`,0.`],List[8563.1455078125`,0.`],List[9253.703125`,0.`],List[9999.9501953125`,0.`],List[10806.376953125`,0.`],List[11677.8359375`,0.`],List[12619.572265625`,0.`],List[13637.2529296875`,0.`],List[14737.0029296875`,0.`],List[15925.4404296875`,0.`],List[17209.716796875`,0.`],List[18597.560546875`,0.`],List[20097.32421875`,0.`],List[21718.033203125`,0.`],List[23469.44140625`,0.`],List[25362.08984375`,0.`],List[27407.365234375`,0.`],List[29617.580078125`,0.`],List[32006.03125`,0.`],List[34587.09375`,0.`],List[37376.3046875`,0.`],List[40390.4453125`,0.`],List[43647.65234375`,0.`],List[47167.53125`,0.`],List[50971.265625`,0.`],List[55081.74609375`,0.`],List[59523.703125`,0.`],List[64323.87890625`,0.`],List[69511.1484375`,0.`],List[75116.7421875`,0.`],List[81174.3828125`,0.`],List[87720.5390625`,0.`],List[94794.5859375`,0.`],List[102439.109375`,0.`],List[110700.1171875`,0.`],List[119627.3125`,0.`],List[129274.421875`,0.`],List[139699.5`,0.`],List[150965.296875`,0.`],List[163139.59375`,0.`],List[176295.671875`,0.`],List[190512.703125`,0.`],List[205876.21875`,0.`],List[222478.703125`,0.`],List[240420.078125`,0.`],List[259808.28125`,0.`],List[280760.`,0.`],List[303401.34375`,0.`],List[327868.5625`,0.`],List[354308.875`,0.`],List[382881.4375`,0.`],List[413758.15625`,0.`],List[447124.875`,0.`],List[483182.40625`,0.`],List[522147.71875`,0.`],List[564255.3125`,0.`],List[609758.5625`,0.`],List[658931.375`,0.`],List[712069.5625`,0.`],List[769493.0625`,0.`],List[831547.3125`,0.`],List[898605.8125`,0.`],List[971072.125`,0.`],List[1.049382375`*^6,0.`],List[1.13400775`*^6,0.`],List[1.225457625`*^6,0.`],List[1.32428225`*^6,0.`],List[1.431076375`*^6,0.`],List[1.54648275`*^6,0.`],List[1.671195875`*^6,0.`],List[1.80596625`*^6,0.`],List[1.951604875`*^6,0.`],List[2.10898825`*^6,0.`],List[2.2790635`*^6,0.`],List[2.462854`*^6,0.`],List[2.66146625`*^6,0.`],List[2.876095`*^6,0.`],List[3.108032`*^6,0.`],List[3.35867325`*^6,0.`],List[3.62952675`*^6,0.`],List[3.922223`*^6,0.`],List[4.238523`*^6,0.`],List[4.5803305`*^6,0.`],List[4.949702`*^6,0.`],List[5.3488615`*^6,0.`],List[5.78021`*^6,0.`],List[6.2463435`*^6,0.`]],List["Nanometers",IndependentUnit["ArbitraryUnits"]],List[List[1],List[2]]]];

				(* -- FAKE DynamicLightScattering DATA OBJECT -- *)
				dataObject1 = Upload[<|
					Type -> Object[Data, DynamicLightScattering],
					Name -> "Fake data 1 for PlotDynamicLightScattering tests",
					AssayType->SizingPolydispersity,
					MassDistribution->massDistribution,
					IntensityDistribution->massDistribution

				|>];

				dataObject2 = Upload[<|
					Type -> Object[Data, DynamicLightScattering],
					Name -> "Fake replicate data 1 for PlotDynamicLightScattering tests",
					AssayType->SizingPolydispersity,
					MassDistribution->massDistribution,
					IntensityDistribution->massDistribution
				|>];

				(* data objects for data melting curve *)
				initialMassDistribution = QuantityArray[
 				StructuredArray`StructuredData[List[41, 2],
  				List[List[List[1.14903593063354`, 0.`],
			    List[1.24278044700623`, 0.`], List[1.34417319297791`, 0.`],
			    List[1.45383810997009`, 0.`], List[1.57245016098022`, 0.`],
			    List[1.70073914527893`, 0.`],
			    List[1.83949458599091`, 0.00727885169908404`],
			    List[1.98957049846649`, 0.0316647104918957`],
			    List[2.15189051628113`, 0.055584941059351`],
			    List[2.32745337486267`, 0.0727681592106819`],
			    List[2.51733946800232`, 0.0826107114553452`],
			    List[2.72271776199341`, 0.0863157212734222`],
			    List[2.94485187530518`, 0.0854268297553062`],
			    List[3.18510866165161`, 0.0813546106219292`],
			    List[3.44496703147888`, 0.0752541348338127`],
			    List[3.72602605819702`, 0.0680195018649101`],
			    List[4.03001546859741`, 0.0603149756789207`],
			    List[4.35880613327026`, 0.0526144430041313`],
			    List[4.71442079544067`, 0.0452398732304573`],
			    List[5.09904909133911`, 0.0383953005075455`],
			    List[5.51505708694458`, 0.0321958251297474`],
			    List[5.96500492095947`, 0.026691285893321`],
			    List[6.45166254043579`, 0.0218853242695332`],
			    List[6.97802400588989`, 0.0177503861486912`],
			    List[7.54732894897461`, 0.0142391817644238`],
			    List[8.16308116912842`, 0.0112932790070772`],
			    List[8.82906913757324`, 0.00884938333183527`],
			    List[9.54939270019531`, 0.00684372102841735`],
			    List[10.328483581543`, 0.00521501386538148`],
			    List[11.1711368560791`, 0.00390633847564459`],
			    List[12.0825386047363`, 0.00286618014797568`],
			    List[13.0682973861694`, 0.0020489189773798`],
			    List[14.1344804763794`, 0.0014149391790852`],
			    List[15.2876472473145`, 0.000930549227632582`],
			    List[16.5348968505859`, 0.000567901530303061`],
			    List[17.883903503418`, 0.000305159046547487`],
			    List[19.3429679870605`, 0.000127189967315644`],
			    List[20.9210720062256`, 0.0000265957605734002`],
			    List[22.6279258728027`, 0.`], List[24.4740352630615`, 0.`],
			    List[26.4707584381104`, 0.`]],
				List["Nanometers", IndependentUnit["ArbitraryUnits"]],
				List[List[1], List[2]]]]];

				finalMassDistribution = QuantityArray[
			 	StructuredArray`StructuredData[List[41, 2],
			  	List[List[List[1.14947009086609`, 0.`],
			    List[1.24325013160706`, 0.`], List[1.34468126296997`, 0.`],
			    List[1.45438754558563`, 0.`], List[1.57304441928864`, 0.`],
			    List[1.7013818025589`, 0.`], List[1.84018981456757`, 0.`],
			    List[1.99032247066498`, 0.`], List[2.15270376205444`, 0.`],
			    List[2.32833290100098`, 0.`], List[2.51829099655151`, 0.`],
			    List[2.72374677658081`, 0.`],
			    List[2.94596457481384`, 0.00280346488580108`],
			    List[3.1863124370575`, 0.0213846378028393`],
			    List[3.44626903533936`, 0.0416925363242626`],
			    List[3.72743439674377`, 0.0579040758311749`],
			    List[4.03153848648071`, 0.0687784999608994`],
			    List[4.3604531288147`, 0.0747341364622116`],
			    List[4.71620273590088`, 0.0766691416501999`],
			    List[5.10097599029541`, 0.0755369663238525`],
			    List[5.51714134216309`, 0.0722005516290665`],
			    List[5.96725940704346`, 0.0673884078860283`],
			    List[6.45410060882568`, 0.0616892762482166`],
			    List[6.98066091537476`, 0.0555620901286602`],
			    List[7.55018138885498`, 0.049351841211319`],
			    List[8.16616630554199`, 0.0433072187006474`],
			    List[8.83240604400635`, 0.0375979319214821`],
			    List[9.55300140380859`, 0.0323306918144226`],
			    List[10.33238697052`, 0.0275634359568357`],
			    List[11.1753587722778`, 0.0233174487948418`],
			    List[12.0871047973633`, 0.0195874907076359`],
			    List[13.0732364654541`, 0.0163500383496284`],
			    List[14.1398220062256`, 0.013569806702435`],
			    List[15.2934246063232`, 0.0112048154696822`],
			    List[16.541145324707`, 0.00921013951301575`],
			    List[17.890661239624`, 0.007540681399405`],
			    List[19.3502788543701`, 0.00615304755046964`],
			    List[20.9289779663086`, 0.00500679016113281`],
			    List[22.6364784240723`, 0.00406512198969722`],
			    List[24.483283996582`, 0.00329525279812515`],
			    List[26.4807624816895`, 0.00266844313591719`]],
			    List["Nanometers", IndependentUnit["ArbitraryUnits"]],
			    List[List[1], List[2]]]]];

				dataObject3 = Upload[<|
					Type -> Object[Data, MeltingCurve],
					Name -> "Good melting curve data for PlotDynamicLightScattering tests",
					Replace[DynamicLightScatteringMeasurements]->{Before, After},
					InitialMassDistribution->initialMassDistribution,
					FinalMassDistribution->finalMassDistribution
				|>];

				dataObject3 = Upload[<|
					Type -> Object[Data, MeltingCurve],
					Name -> "Bad melting curve data for PlotDynamicLightScattering tests"
				|>];


			]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Data, DynamicLightScattering, "Fake data 1 for PlotDynamicLightScattering tests"],
					Object[Data, DynamicLightScattering, "Fake replicate data 1 for PlotDynamicLightScattering tests"],
					Object[Data, MeltingCurve, "Good melting curve data for PlotDynamicLightScattering tests"]
					Object[Data, MeltingCurve, "Bad melting curve data for PlotDynamicLightScattering tests"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
