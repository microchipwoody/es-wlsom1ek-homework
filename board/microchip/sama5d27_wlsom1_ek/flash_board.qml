import SAMBA 3.4
import SAMBA.Connection.Serial 3.4
import SAMBA.Device.SAMA5D2 3.4

SerialConnection {
	//port: "ttyACM0"
	//port: "COM85"
	//baudRate: 57600

	device: SAMA5D2Xplained {
		/* override part of default config */
		config {
			/* use SDCard socket */
			sdmmc {
				instance: 0
			}
		}
	}

	onConnectionOpened: {
		// initialize SD/MMC applet
		initializeApplet("sdmmc")

		// write file
		applet.write(0, "images/sdcard.img", false)

		// initialize boot config applet
		initializeApplet("bootconfig")

		// Use BUREG0 as boot configuration word
		applet.writeBootCfg(BootCfg.BSCR, BSCR.fromText("VALID,BUREG0"))

		// Enable external boot only on SDMMC0
		applet.writeBootCfg(BootCfg.BUREG0,
			BCW.fromText("EXT_MEM_BOOT,UART1_IOSET1,JTAG_IOSET1," +
			             "SDMMC0,SDMMC1_DISABLED,NFC_DISABLED," +
			             "SPI1_DISABLED,SPI0_DISABLED," +
			             "QSPI1_DISABLED,QSPI0_DISABLED"))

		initializeApplet("reset")
	}
}
