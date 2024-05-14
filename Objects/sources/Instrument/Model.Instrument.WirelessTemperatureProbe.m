(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, WirelessTemperatureProbe], {
    Description->"An instrument designed for measuring temperature using wireless data transmission.",
    CreatePrivileges->None,
    Cache->Download,
    Fields -> {
        MaxReadingTemperature->{
            Format -> Single,
            Class -> Real,
            Pattern :> LessEqualP[1300 Celsius],
            Units -> Celsius,
            Description -> "The highest temperature the temperature probe will read and record.",
            Category -> "General"
        },
        MinReadingTemperature->{
            Format -> Single,
            Class -> Real,
            Pattern :> GreaterEqualP[-270 Celsius],
            Units -> Celsius,
            Description -> "The lowest temperature the temperature probe will read.",
            Category -> "General"
        },
        ReadingFrequency->{
            Format -> Single,
            Class -> Real,
            Pattern :>RangeP[10Second,12Hour],
            Units -> Second,
            Description -> "Describes how often a temperature reading is taken.",
            Category -> "General"
        },
        ReadingResolution->{
            Format -> Single,
            Class -> Real,
            Pattern :>LessEqualP[1.5 Celsius],
            Units -> Celsius,
            Description -> "The precision with which the probe reads the temperature.",
            Category -> "General"
        },
        BatteryLife->{
            Format -> Single,
            Class -> Real,
            Pattern :>LessEqualP[6 Month],
            Units -> Month,
            Description -> "Describes how long the probe can keep recording with being charged.",
            Category -> "General"
        }
    }
}];