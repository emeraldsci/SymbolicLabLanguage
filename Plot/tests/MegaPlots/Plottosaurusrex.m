(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Plottosaurusrex *)


DefineTests[Plottosaurusrex,
	{
		Example[{Basic,"Ask to plot NMR data, get a dinosaur:"},
			Plottosaurusrex[Object[Data,NMR,"id:GmzlKjY5eMlp"]],
			_Image
		],
		Example[{Basic,"Ask to plot mass spectroscopy data, get a dinosour:"},
			Plottosaurusrex[Object[Data,MassSpectrometry,"id:N80DNjlYOxPN"]],
			_Image
		],
		Example[{Basic,"Ask to plot microscope data, get a dinosour:"},
			Plottosaurusrex[Object[Data,Microscope,"id:4pO6dMWv6qZ7"]],
			_Image
		],
		Example[{Additional,"Ask to plot a dinosour, get a dinosour:"},
			Plottosaurusrex[Object[User,Emerald,Developer,"id:3em6ZvLJ6Dl7"]],
			_Image
		]
	}
];
