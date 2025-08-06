* PWL waveform for EN
* VEN EN 0 PWL(0.0n 0.0V 200.0n 0.0V 230.0n {vdd} 370.0n {vdd} 400n 0.0V 600.0n 0V 630n {vdd} 770.0n {vdd} 800n 0.0V 1000.0n 0V 1030n {vdd})
* PWL waveform for nEN (non-overlapping)
* VnEN nEN 0 PWL(0.0n {vdd} 170.0n {vdd} 200.0n 0.0V 400.0n 0.0V 430n {vdd} 570.0n {vdd} 600n 0V 800.0n 0V 830n {vdd} 970.0n {vdd} 1000n 0V)


* PWL waveform for CLK
VCLK CLK 0 PWL(0.0n 0.0V 200.0n 0.0V 230.0n {vdd} 400.0n {vdd} 430n 0.0V 600.0n 0V 630n {vdd} 800.0n {vdd} 830n 0.0V 1000.0n 0V 1030n {vdd})
* PWL waveform for nCLK (non-overlapping)
VnCLK nCLK 0 PWL(0.0n {vdd} 200.0n {vdd} 230.0n 0.0V 400.0n 0.0V 430n {vdd} 600.0n {vdd} 630n 0V 800.0n 0V 830n {vdd} 1000.0n {vdd} 1030n 0V)

* PWL waveform for D
VD D 0 PWL(240n {vdd} 270n 0.0V 300n 0V 330n {vdd} 350n {vdd} 380n 0V 500n 0V 530n {vdd} 650n {vdd} 680n 0V 710n 0V 740n {vdd} 850n {vdd} 880n 0V)