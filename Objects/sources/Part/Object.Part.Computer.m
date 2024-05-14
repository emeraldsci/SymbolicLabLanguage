

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, Computer], {
	Description -> "Information regarding the hardware and software details of instrument, workstation, and tablet computers.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {

    DateInstalled -> {
      Format -> Single,
      Class -> Date,
      Pattern :> _?DateObjectQ,
      Description -> "The date at which this computer was put into service.",
      Category -> "Organizational Information"
    },

    ComputerIP -> {
      Format -> Single,
      Class -> String,
      Pattern :> IpP,
      Description -> "The numerical identifier for this computer, used for VNC and network access.",
            Category -> "Part Specifications"
    },

    Hostname -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The unique label assigned to this computer connected to the network. This does not include the network domain of the site where this computer is located.",
      Category -> "Part Specifications"
    },

    BackupHardDrive -> {
      Format -> Multiple,
      Class -> {Date, Link},
      Pattern :> {_?DateObjectQ, _Link},
      Relation -> {Null, Object[Part,InformationTechnology][ComputerBackup]},
      Headers->{"Date", "Hard Drive"},
      Description -> "The backup hard drive object(s) created to save the working condition of the computer, and the date they were created.",
      Category -> "Part Specifications"
    },

    InstrumentSoftware -> {
      Format -> Multiple,
      Class -> {Expression, String},
      Pattern :> {InstrumentSoftwareP, _String},
      Description -> "The instrument-specific software that this computer has installed.",
      Category -> "Part Specifications",
            Headers -> {"Software Name", "Version Number"}
    },

    Instruments -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Alternatives[Object[Instrument][Computer],Object[Instrument][VideoCaptureComputer]],
      Description -> "The instrument(s) that this computer is controlling for the purpose of acquiring data.",
      Category -> "Usage Information"
    },

    StickerPrinters -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Part, StickerPrinter][Computer],
      Description -> "The sticker printer(s) that this computer is controlling for the purpose of printing out labels.",
      Category -> "Usage Information"
    },

    VirtualNetworkConnection -> {
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[EmeraldCloudFile],
      Description -> "The connection file used to VNC into instrument computers. Using version 6.21.1109 x64.",
      Category -> "Usage Information"
    },

    FullyQualifiedDomainName -> {
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "The absolute domain name of this computer device. This includes both the hostname of this computer and the network domain of the computer's site to make the full computer DHCP address.",
      Category -> "Part Specifications"
    },

    ConnectedKVMSwitch ->{
      Format -> Single,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Part,KVMSwitch][ConnectedComputers],
      Description -> "The KVMSwitch that is capable of controlling this computer.",
      Category -> "Part Specifications"
    }

	}
}];
