
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x1,0x2,0x4,0x8,0x10,0x20,0x40,0x80

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _led
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : LedDon
;Version : 0.1
;Date    : 21-Oct-2018
;Author  : DuyKhanh
;Company : GTS
;Comments:
;No
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#define LED PORTA
;#define Off 0x00
;#define On 0xff;
;
;// Declare your global variables here
;char led[] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};

	.DSEG
;
;
;
;void MotLedSangDuoiQuaLai()//cong tat 1
; 0000 0025 {

	.CSEG
_MotLedSangDuoiQuaLai:
; 0000 0026     int i = 0;
; 0000 0027     while(PINB == 0x01)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x4:
	IN   R30,0x16
	CPI  R30,LOW(0x1)
	BRNE _0x6
; 0000 0028     {
; 0000 0029         if(i > 7){
	__CPWRN 16,17,8
	BRLT _0x7
; 0000 002A         i = 0;
	__GETWRN 16,17,0
; 0000 002B         }
; 0000 002C         LED = led[i];
_0x7:
	LDI  R26,LOW(_led)
	LDI  R27,HIGH(_led)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RCALL SUBOPT_0x0
; 0000 002D         delay_ms(20);
; 0000 002E         i++;
	__ADDWRN 16,17,1
; 0000 002F     }
	RJMP _0x4
_0x6:
; 0000 0030 
; 0000 0031 }
	RJMP _0x2000003
;
;void TamLedSangDanTatDan()//cong tat 2
; 0000 0034 {
_TamLedSangDanTatDan:
; 0000 0035     unsigned char i;
; 0000 0036     while(PINB==0x02){
	ST   -Y,R17
;	i -> R17
_0x8:
	IN   R30,0x16
	CPI  R30,LOW(0x2)
	BRNE _0xA
; 0000 0037         //SANG DAN
; 0000 0038         LED = Off;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0039         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0xC:
	CPI  R17,8
	BRSH _0xD
; 0000 003A         {
; 0000 003B             LED = (LED<<1)| 0x01;
	IN   R30,0x1B
	LSL  R30
	ORI  R30,1
	RCALL SUBOPT_0x0
; 0000 003C             delay_ms(20);
; 0000 003D         }
	SUBI R17,-1
	RJMP _0xC
_0xD:
; 0000 003E         //TAT DAN
; 0000 003F         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0xF:
	CPI  R17,8
	BRSH _0x10
; 0000 0040         {
; 0000 0041             LED = LED<<1;
	IN   R30,0x1B
	LSL  R30
	RCALL SUBOPT_0x0
; 0000 0042             delay_ms(20);
; 0000 0043         }
	SUBI R17,-1
	RJMP _0xF
_0x10:
; 0000 0044     }
	RJMP _0x8
_0xA:
; 0000 0045 }
	LD   R17,Y+
	RET
;
;void SangTu2BenVao_TatTu2BenVao()//cong tat 3
; 0000 0048 {
_SangTu2BenVao_TatTu2BenVao:
; 0000 0049     int i;
; 0000 004A     unsigned char x = 0b00000001;
; 0000 004B     unsigned char y = 0b10000000;
; 0000 004C     for(i = 0; i < 4; i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	x -> R19
;	y -> R18
	LDI  R19,1
	LDI  R18,128
	__GETWRN 16,17,0
_0x12:
	__CPWRN 16,17,4
	BRGE _0x13
; 0000 004D     {
; 0000 004E         LED += (x+y);
	IN   R30,0x1B
	MOV  R26,R30
	MOV  R30,R18
	ADD  R30,R19
	ADD  R30,R26
	RCALL SUBOPT_0x0
; 0000 004F         delay_ms(20);
; 0000 0050         x = (x<<1);
	RCALL SUBOPT_0x1
; 0000 0051         y = (y>>1);
; 0000 0052     }
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
; 0000 0053     x = 0b00000001;
	LDI  R19,LOW(1)
; 0000 0054     y = 0b10000000;
	LDI  R18,LOW(128)
; 0000 0055     for(i = 0; i < 4; i++)
	__GETWRN 16,17,0
_0x15:
	__CPWRN 16,17,4
	BRGE _0x16
; 0000 0056     {
; 0000 0057         LED -= (x+y);
	IN   R0,27
	CLR  R1
	MOV  R26,R19
	CLR  R27
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x0
; 0000 0058         delay_ms(20);
; 0000 0059         x = (x<<1);
	RCALL SUBOPT_0x1
; 0000 005A         y = (y>>1);
; 0000 005B     }
	__ADDWRN 16,17,1
	RJMP _0x15
_0x16:
; 0000 005C }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void MotLedChayTuTraiQuaPhaiDungLaiOBenPhaiChoDenKhi8LedCungSang()//cong tat 4
; 0000 005F {
_MotLedChayTuTraiQuaPhaiDungLaiOBenPhaiChoDenKhi8LedCungSang:
; 0000 0060     unsigned char x = 0b00000000;
; 0000 0061     unsigned char y = 0b00000000;
; 0000 0062     int i,j;
; 0000 0063     for(i = 0; i < 8; i++)
	CALL __SAVELOCR6
;	x -> R17
;	y -> R16
;	i -> R18,R19
;	j -> R20,R21
	LDI  R17,0
	LDI  R16,0
	__GETWRN 18,19,0
_0x18:
	__CPWRN 18,19,8
	BRGE _0x19
; 0000 0064     {
; 0000 0065         x = 0b00000000;
	LDI  R17,LOW(0)
; 0000 0066          for(j = i; j < 8; j++)
	MOVW R20,R18
_0x1B:
	__CPWRN 20,21,8
	BRGE _0x1C
; 0000 0067          {
; 0000 0068             LED = x + y;
	MOV  R30,R16
	ADD  R30,R17
	RCALL SUBOPT_0x0
; 0000 0069             delay_ms(20);
; 0000 006A             x = (x<<1);
	LSL  R17
; 0000 006B             if(j == i)
	__CPWRR 18,19,20,21
	BRNE _0x1D
; 0000 006C             {
; 0000 006D                 x+=1;
	SUBI R17,-LOW(1)
; 0000 006E             }
; 0000 006F          }
_0x1D:
	__ADDWRN 20,21,1
	RJMP _0x1B
_0x1C:
; 0000 0070          y += x;
	ADD  R16,R17
; 0000 0071          if(i == 7)
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x1E
; 0000 0072          {
; 0000 0073             LED = y;
	RCALL SUBOPT_0x2
; 0000 0074             delay_ms(20);
; 0000 0075          }
; 0000 0076     }
_0x1E:
	__ADDWRN 18,19,1
	RJMP _0x18
_0x19:
; 0000 0077 }
	RJMP _0x2000001
;
;void TamLedChopTat()//cong tat 5
; 0000 007A {
_TamLedChopTat:
; 0000 007B     unsigned char x = Off;
; 0000 007C     unsigned char y = On;
; 0000 007D     LED = x;
	ST   -Y,R17
	ST   -Y,R16
;	x -> R17
;	y -> R16
	LDI  R17,0
	LDI  R16,255
	RJMP _0x2000002
; 0000 007E     delay_ms(20);
; 0000 007F     LED = y;
; 0000 0080     delay_ms(20);
; 0000 0081 }
;
;void TamLedSangTatXenKe()//cong tat 6
; 0000 0084 {
_TamLedSangTatXenKe:
; 0000 0085     unsigned char a = 0b10101010;
; 0000 0086     unsigned char b = 0b01010101;
; 0000 0087     LED = a;
	ST   -Y,R17
	ST   -Y,R16
;	a -> R17
;	b -> R16
	LDI  R17,170
	LDI  R16,85
	RJMP _0x2000002
; 0000 0088     delay_ms(20);
; 0000 0089     LED = b;
; 0000 008A     delay_ms(20);
; 0000 008B }
;
;void BonLedSangBonLedTat()//cong tat 7
; 0000 008E {
_BonLedSangBonLedTat:
; 0000 008F    unsigned char a = 0b00001111;
; 0000 0090    unsigned char b = 0b11110000;
; 0000 0091    LED = a;
	ST   -Y,R17
	ST   -Y,R16
;	a -> R17
;	b -> R16
	LDI  R17,15
	LDI  R16,240
_0x2000002:
	OUT  0x1B,R17
; 0000 0092    delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0093    LED = b;
	RCALL SUBOPT_0x2
; 0000 0094    delay_ms(20);
; 0000 0095 }
_0x2000003:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void HaiLedSangChayTuHaiBenVaoVaChayRaHaiBen()//cong tat 8
; 0000 0098 {
_HaiLedSangChayTuHaiBenVaoVaChayRaHaiBen:
; 0000 0099     int i,j;
; 0000 009A     unsigned char a = 0b00000001;
; 0000 009B     unsigned char b = 0b10000000;
; 0000 009C     for(i = 0; i < 4; i++)
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	a -> R21
;	b -> R20
	LDI  R21,1
	LDI  R20,128
	__GETWRN 16,17,0
_0x20:
	__CPWRN 16,17,4
	BRGE _0x21
; 0000 009D     {
; 0000 009E         LED = a+b;
	MOV  R30,R20
	ADD  R30,R21
	RCALL SUBOPT_0x0
; 0000 009F         delay_ms(20);
; 0000 00A0         a = (a<<1);
	RCALL SUBOPT_0x3
; 0000 00A1         b = (b>>1);
; 0000 00A2     }
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 00A3     a = 0b00010000;
	LDI  R21,LOW(16)
; 0000 00A4     b = 0b00001000;
	LDI  R20,LOW(8)
; 0000 00A5     for(i = 0; i < 4; i++)
	__GETWRN 16,17,0
_0x23:
	__CPWRN 16,17,4
	BRGE _0x24
; 0000 00A6     {
; 0000 00A7         LED = a+b;
	MOV  R30,R20
	ADD  R30,R21
	RCALL SUBOPT_0x0
; 0000 00A8         delay_ms(20);
; 0000 00A9         a = (a<<1);
	RCALL SUBOPT_0x3
; 0000 00AA         b = (b>>1);
; 0000 00AB     }
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
; 0000 00AC }
_0x2000001:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;
;
;
;
;
;
;
;void main(void)
; 0000 00B5 {
_main:
; 0000 00B6 // Declare your local variables here
; 0000 00B7 
; 0000 00B8 
; 0000 00B9 
; 0000 00BA /*-------------*/
; 0000 00BB PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00BC DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00BD /*-------------*/
; 0000 00BE PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00BF DDRB=0x00;
	OUT  0x17,R30
; 0000 00C0 /*-------------*/
; 0000 00C1 PORTC=0x00;
	OUT  0x15,R30
; 0000 00C2 DDRC=0x00;
	OUT  0x14,R30
; 0000 00C3 /*-------------*/
; 0000 00C4 PORTD=0x00;
	OUT  0x12,R30
; 0000 00C5 DDRD=0x00;
	OUT  0x11,R30
; 0000 00C6 /*-------------*/
; 0000 00C7 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00C8 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00C9 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00CA 
; 0000 00CB /*----------------------------*/
; 0000 00CC TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00CD TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00CE TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00CF TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00D0 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00D1 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00D2 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D3 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00D4 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00D5 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D6 /*----------------------------*/
; 0000 00D7 ASSR=0x00;
	OUT  0x22,R30
; 0000 00D8 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00D9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DA OCR2=0x00;
	OUT  0x23,R30
; 0000 00DB /*----------------------------*/
; 0000 00DC MCUCR=0x00;
	OUT  0x35,R30
; 0000 00DD MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00DE /*----------------------------*/
; 0000 00DF TIMSK=0x00;
	OUT  0x39,R30
; 0000 00E0 /*----------------------------*/
; 0000 00E1 UCSRB=0x00;
	OUT  0xA,R30
; 0000 00E2 /*----------------------------*/
; 0000 00E3 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E4 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E5 /*----------------------------*/
; 0000 00E6 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00E7 /*----------------------------*/
; 0000 00E8 SPCR=0x00;
	OUT  0xD,R30
; 0000 00E9 /*----------------------------*/
; 0000 00EA TWCR=0x00;
	OUT  0x36,R30
; 0000 00EB 
; 0000 00EC while (1)
_0x25:
; 0000 00ED       {
; 0000 00EE         switch(PINB)
	IN   R30,0x16
; 0000 00EF         {
; 0000 00F0             case 0x01:{//Cong tat 1
	CPI  R30,LOW(0x1)
	BRNE _0x2B
; 0000 00F1 
; 0000 00F2             while(PINB == 0x01)
_0x2C:
	IN   R30,0x16
	CPI  R30,LOW(0x1)
	BRNE _0x2E
; 0000 00F3             {
; 0000 00F4                 MotLedSangDuoiQuaLai();
	RCALL _MotLedSangDuoiQuaLai
; 0000 00F5             }
	RJMP _0x2C
_0x2E:
; 0000 00F6             PORTA = Off;
	RJMP _0x4C
; 0000 00F7             delay_ms(10);
; 0000 00F8             break;
; 0000 00F9             }
; 0000 00FA             case 0x02:{//Cong tat 2
_0x2B:
	CPI  R30,LOW(0x2)
	BRNE _0x2F
; 0000 00FB             while(PINB == 0x02){
_0x30:
	IN   R30,0x16
	CPI  R30,LOW(0x2)
	BRNE _0x32
; 0000 00FC                  TamLedSangDanTatDan();
	RCALL _TamLedSangDanTatDan
; 0000 00FD             }
	RJMP _0x30
_0x32:
; 0000 00FE                 LED = Off;
	RJMP _0x4C
; 0000 00FF                 delay_ms(10);
; 0000 0100                 break;
; 0000 0101             }
; 0000 0102 
; 0000 0103             case 0x04:{//Cong tat 3
_0x2F:
	CPI  R30,LOW(0x4)
	BRNE _0x33
; 0000 0104                 while(PINB == 0x04)
_0x34:
	IN   R30,0x16
	CPI  R30,LOW(0x4)
	BRNE _0x36
; 0000 0105                 {
; 0000 0106                    SangTu2BenVao_TatTu2BenVao();
	RCALL _SangTu2BenVao_TatTu2BenVao
; 0000 0107                 }
	RJMP _0x34
_0x36:
; 0000 0108                 LED = Off;
	RJMP _0x4C
; 0000 0109                 delay_ms(10);
; 0000 010A                 break;
; 0000 010B             }
; 0000 010C 
; 0000 010D             case 0x08:{//Cong tat 4
_0x33:
	CPI  R30,LOW(0x8)
	BRNE _0x37
; 0000 010E                 while(PINB == 0x08)
_0x38:
	IN   R30,0x16
	CPI  R30,LOW(0x8)
	BRNE _0x3A
; 0000 010F                 {
; 0000 0110                    MotLedChayTuTraiQuaPhaiDungLaiOBenPhaiChoDenKhi8LedCungSang();
	RCALL _MotLedChayTuTraiQuaPhaiDungLaiOBenPhaiChoDenKhi8LedCungSang
; 0000 0111                 }
	RJMP _0x38
_0x3A:
; 0000 0112                 LED = Off;
	RJMP _0x4C
; 0000 0113                 delay_ms(10);
; 0000 0114                 break;
; 0000 0115             }
; 0000 0116 
; 0000 0117             case 0x10:{//Cong tat 5
_0x37:
	CPI  R30,LOW(0x10)
	BRNE _0x3B
; 0000 0118                 while(PINB == 0x10)
_0x3C:
	IN   R30,0x16
	CPI  R30,LOW(0x10)
	BRNE _0x3E
; 0000 0119                 {
; 0000 011A                     TamLedChopTat();
	RCALL _TamLedChopTat
; 0000 011B                 }
	RJMP _0x3C
_0x3E:
; 0000 011C                 LED = Off;
	RJMP _0x4C
; 0000 011D                 delay_ms(10);
; 0000 011E                 break;
; 0000 011F             }
; 0000 0120 
; 0000 0121             case 0x20:{//Cong tat 6
_0x3B:
	CPI  R30,LOW(0x20)
	BRNE _0x3F
; 0000 0122                 while(PINB == 0x20)
_0x40:
	IN   R30,0x16
	CPI  R30,LOW(0x20)
	BRNE _0x42
; 0000 0123                 {
; 0000 0124                     TamLedSangTatXenKe();
	RCALL _TamLedSangTatXenKe
; 0000 0125                 }
	RJMP _0x40
_0x42:
; 0000 0126                 LED = Off;
	RJMP _0x4C
; 0000 0127                 delay_ms(10);
; 0000 0128                 break;
; 0000 0129             }
; 0000 012A 
; 0000 012B             case 0x40:{//Cong tat 7
_0x3F:
	CPI  R30,LOW(0x40)
	BRNE _0x43
; 0000 012C                 while(PINB == 0x40)
_0x44:
	IN   R30,0x16
	CPI  R30,LOW(0x40)
	BRNE _0x46
; 0000 012D                 {
; 0000 012E                    BonLedSangBonLedTat();
	RCALL _BonLedSangBonLedTat
; 0000 012F                 }
	RJMP _0x44
_0x46:
; 0000 0130                 LED = Off;
	RJMP _0x4C
; 0000 0131                 delay_ms(10);
; 0000 0132                 break;
; 0000 0133             }
; 0000 0134 
; 0000 0135             case 0x80:{//Cong tat 8
_0x43:
	CPI  R30,LOW(0x80)
	BRNE _0x2A
; 0000 0136                 while(PINB == 0x80)
_0x48:
	IN   R30,0x16
	CPI  R30,LOW(0x80)
	BRNE _0x4A
; 0000 0137                 {
; 0000 0138                    HaiLedSangChayTuHaiBenVaoVaChayRaHaiBen();
	RCALL _HaiLedSangChayTuHaiBenVaoVaChayRaHaiBen
; 0000 0139                 }
	RJMP _0x48
_0x4A:
; 0000 013A                 LED = Off;
_0x4C:
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 013B                 delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 013C                 break;
; 0000 013D             }
; 0000 013E 
; 0000 013F         }
_0x2A:
; 0000 0140 
; 0000 0141       }
	RJMP _0x25
; 0000 0142 }
_0x4B:
	RJMP _0x4B
;
;
;
;
;
;
;//*----------------------------------------------*//
;//                    int a = 1;
;//                    int i;
;//                    for(i = 0; i < 7; i++) {
;//                        a = a<<1;
;//                        PORTA = a;
;//                        delay_ms(50);
;//                    }
;//                     for(i = 0; i < 7; i++) {
;//                         a = a>>1;
;//                         PORTA = a;
;//                         delay_ms(50);
;//                     }
;//                     PORTA = 0x00;
;//                     break;
;//*----------------------------------------------*//
;
;
;
;
;
;//*------------------case 0x02----------------------------*//
;//                count = 0;
;//                dir = 0;// left to right
;//                while(PINB == 0x02)
;//                {
;//                    LED = led[count];
;//                    delay_ms(15);
;//                   if(dir == 0){
;//                        count++;
;//                        if(count >= 7)
;//                        {
;//                            dir = 1;//right to left
;//                        }
;//                   } else {
;//                        count--;
;//                        if(count <= 0)
;//                        {
;//                             dir = 0;
;//                        }
;//                   }
;//                }
;//                LED = 0x00;
;//                delay_ms(10);
;//*----------------------------------------------*//
;
;
;
;
;/*-----------Sang dan tu trai qua phai xong tat dan tu phai qua trai----------*/
;//                dir = 0; //left to right
;//                val = 0;
;//                LED = Off;
;//                while(PINB == 0x04)
;//                {
;//                    PORTA = val;
;//                    delay_ms(20);
;//                    if(dir == 0)
;//                    {
;//                        val = val << 1;
;//                        val = val + 1;
;//                        if(val > 255)
;//                        {
;//                            dir = 1;
;//                        }
;//                        if(PINB != 0x04)
;//                        {
;//                            PORTA = 0x00;
;//                            delay_ms(10);
;//                            break;
;//                        }
;//                    }
;//                    else
;//                    {
;//                        val = val >> 1;
;//                        if(val <= 0)
;//                        {
;//                            dir = 0;
;//                        }
;//                        if(PINB != 0x04)
;//                        {
;//                            PORTA = 0x00;
;//                            delay_ms(10);
;//                            break;
;//                        }
;//                    }
;//             }
;/*-----------Sang dan tu trai qua phai xong tat dan tu phai qua trai----------*/
;
;
;
;
;
;/*---------------------------------------------------------*/
;//                //0000 0000 0
;//                //1000 0001 129
;//                //0100 0010 195
;//                //0010 0100
;//                //0001 1000
;//                dir = 0;
;//                val_1 = 0x80;
;//                val_2 = 0x01;
;//                while(1)
;//                {
;//                    PORTA = val_1 + val_2;
;//                    delay_ms(50);
;//                    if(dir == 0)
;//                    {
;//                        val_1 = val_1 >> 1;
;//                        val_2 = val_2 << 1;
;//                        if(val_2 > 8)
;//                        {
;//                            val_1 = 0x10; //0001 0000
;//                            val_2 = 0x08; //0000 1000
;//                            dir = 1;
;//                        }
;//                    }
;//                    else
;//                    {   if(val_2 == 0x00 )
;//                        {
;//                            val_1 = 0x80;
;//                            val_2 = 0x01;
;//                            dir = 0;
;//                        }
;//                        else
;//                        {
;//                            val_1 = val_1 << 1;
;//                            val_2 = val_2 >> 1;
;//                        }
;//                    }
;/*---------------------------------------------------------*/
;
;
;
;
;/*-----Sang tu 2 ben vao va tat tu 2 ben vao (chua duoc)------*/
;//   unsigned char i;
;//   unsigned char a = 0x01;
;//   unsigned char b = 0x80;
;//   int x = 0;
;//   x = 0; a = 0x01;b = 0x80;
;//   while(PINB==0x04){
;//   LED = Off;
;//      if(x > 3)
;//      {
;//        unsigned char x;
;//        unsigned char y;
;//        for(i=0;i<3;i++)
;//        {
;//            x = a<<1;
;//            y = b>>1;
;//            LED = x+y;
;//            delay_ms(20);
;//
;//        }
;//
;//        delay_ms(20);
;//        LED = Off;
;//          x = 0; a = 0x01;b = 0x80;
;//      }
;//
;//      else {
;//         LED = a+b;
;//         delay_ms(30);
;//         a = (a<<1)| 0x01;
;//         b = (b>>1)| 0x80;
;//         x++;
;//         }
;//
;//   }
;/*------------------------------------------------*/

	.DSEG
_led:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x0:
	OUT  0x1B,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LSL  R19
	MOV  R30,R18
	LDI  R31,0
	ASR  R31
	ROR  R30
	MOV  R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	OUT  0x1B,R16
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LSL  R21
	MOV  R30,R20
	LDI  R31,0
	ASR  R31
	ROR  R30
	MOV  R20,R30
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
