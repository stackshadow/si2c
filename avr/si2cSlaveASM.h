

// Temporary registers
// Some registers
#define		rTemp1		r16
#define		rTemp2		r17
#define		rTemp3		r18
#define		rTimer		r21
#define		rTimer1		r22
#define		rTimer2		r23

// Function Registers
#define		rParameter		r18
#define		rReturnValue	r19
#define		rReturnState	r20

.extern		si2cByte;
.extern		si2cRegisterIndex;

// Functions
.extern 	si2cSlaveReadRegister;
.extern 	si2cSlaveWriteRegister;


#define 	PIN_ASM_( port, bit) _SFR_IO_ADDR( PIN##port ), bit
#define 	PIN_ASM( port, bit) PIN_ASM_( port, bit) /**< Set a bit inside an register */

#define		SCL_ASM PIN_ASM(CONF_SI2C_PORT,CONF_SI2C_CLK) /**< Checks if SCL is set */
#define		SDA_ASM PIN_ASM(CONF_SI2C_PORT,CONF_SI2C_SDA) /**< Checks if SDA is set */

#define		SET_ASM_(typ, port, bit) sbi _SFR_IO_ADDR( typ##port ), bit
#define		SET_ASM(typ, port, bit) SET_ASM_(typ, port, bit)

#define		CLR_ASM_(typ, port, bit) cbi _SFR_IO_ADDR( typ##port ), bit
#define		CLR_ASM(typ, port, bit) CLR_ASM_(typ, port, bit)

