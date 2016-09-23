;----------------------------------------------------------------------------------
;--	License terms :
;--	You are free to use this code as long as you
;--		(i) DO NOT post it on any public repository;
;--		(ii) use it only for educational purposes;
;--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
;--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
;--		(v) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
;--		(vi) retain this notice in this file or any files derived from this.
;----------------------------------------------------------------------------------
;>>> Please note that syntax highlighting might not work properly for some keywords - one of the many bugs in ARM/Keil assembler.
;>>> Make sure you do a 'Rebuild All' before you start a debug session () every time you make some changes in code.
;>>> Also note that you do a CPU reset in the simulator, the REF_ADDR (memory storing variables) in the simulator might not get reset.
	AREA    MYCODE, CODE, READONLY, ALIGN=9 
		ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 128
		LDR	 R12, DIPS  			; load address of DIP switches. DO NOT use pseudo-instructions
		LDR  R11, LEDS  			; load address of LEDs
		LDR  R10, PBTN  			; load address of PBTN
		LDR  R9,  NEXT_INSTR		; load address of UART
		LDR  R8,  DIPS_DATA_MASK	; load reference address
		LDR  R7,  DELAY_CYCLES		; load delay cycles
		LDR  R6,  ZERO				; load zero
		LDR  R3,  COUNT_INTERVAL	; load count interval
		; R1 contains 8 bits data to be displayed on LED
		; R2 contains actual data that is being operated on for unsigned count up and and signed count up/down
		; R2 is left shift of R1 by 24 bits, so that effects of the carry bit on the flags can be observed  
		
POLL_INSTR_TYPE
		STR	 R6, [R11]					; Clear LED
		LDR	 R4, [R10]					; Read instr type from PBTN
		LDR  R5, COUNTD_OPCODE			; Test for COUNTD_OP
		CMP  R4, R5		
		BEQ  COUNTD_OP
		LDR  R5, COUNTU_SIGNED_OPCODE	; Test for COUNTU_SIGNED_OP
		CMP  R4, R5		
		BEQ  COUNTU_SIGNED_OP
		LDR  R5, COUNTD_SIGNED_OPCODE	; Test for COUNTD_SIGNED_OP
		CMP  R4, R5	
		BEQ  COUNTD_SIGNED_OP
		LDR  R5, COUNTU_OPCODE			; Test for COUNTU_OP
		CMP  R4, R5		
		BEQ  COUNTU_OP
		B	 POLL_INSTR_TYPE			; Keep polling until a valid type is entered

COUNTD_OP
		LDR  R1,  [R12]				; Load from DIPS
		AND  R1,  R8				; Take in only bits 7 downto 0
COUNTD_LOOP
		STR  R1,  [R11]				; Display loaded data on LED
		STR  R15, [R9]				; Store next instruction address after DELAY
		; ADD  R9,  R15, #0			; Store next instruction address after DELAY
		B DELAY			
		SUBS R1,  #16				; Count down
		BPL COUNTD_LOOP				; Continue counting if count is positive (N not set)
		BMI POLL_INSTR_TYPE			; Break if count is negative (N set)
		
COUNTU_SIGNED_OP
		LDR  R1,  [R12]				; Load from DIPS
		AND  R1,  R8				; Take in only bits 7 downto 0
		ADD  R2,  R6, R1, LSL #24	; Alight bits 7 downto 0 with bits 31 downto 16, to show the effects of overflow
COUNTU_SIGNED_LOOP
		STR  R1,  [R11]				; Display loaded data on LED
		STR  R15, [R9]				; Store next instruction address after DELAY
		; ADD  R9,  R15, #0			; Store next instruction address after DELAY
		B DELAY			
		ADD  R1,  #16				; Count up counter that is not left shifted, for display purpose only
		ADDS R2,  R3				; Count up counter that is left shifted, this is the real counting where flags are updated
		BVC COUNTU_SIGNED_LOOP		; Continue counting if overflow is clear (V not set)
		BVS POLL_INSTR_TYPE			; Break if count if overflow is set (V set)
		
COUNTD_SIGNED_OP		
		LDR  R1,  [R12]				; Load from DIPS
		AND  R1,  R8				; Take in only bits 7 downto 0
		ADD  R2,  R6, R1, LSL #24	; Alight bits 7 downto 0 with bits 31 downto 16, to show the effects of overflow
COUNTD_SIGNED_LOOP
		STR  R1,  [R11]				; Display loaded data on LED
		STR  R15, [R9]				; Store next instruction address (PC + 8) after DELAY_CYCLES
		; ADD  R9,  R15, #0			; Store next instruction address after DELAY
		B DELAY		
		SUB  R1,  #16				; Count down counter that is not left shifted, for display purpose only
		SUBS R2,  R3				; Count down counter that is left shifted, this is the real counting where flags are updated
		BVC COUNTD_SIGNED_LOOP		; Continue counting if overflow is clear (V not set)
		BVS POLL_INSTR_TYPE			; Break if count has overflow is set (V set)

COUNTU_OP
		LDR  R1,  [R12]				; Load from DIPS
		AND  R1,  R8				; Take in only bits 7 downto 0
		ADD  R2,  R6, R1, LSL #24	; Alight bits 7 downto 0 with bits 31 downto 16, to show the effects of carry
COUNTU_LOOP
		STR  R1,  [R11]				; Display loaded data on LED
		STR  R15, [R9]				; Store next instruction address after DELAY
		; ADD  R9,  R15, #0			; Store next instruction address after DELAY
		B DELAY		
		ADD  R1,  #16				; Count up counter that is not left shifted, for display purpose only	
		ADDS R2,  R3 				; Count up counter that is left shifted, this is the real counting where flags are updated
		BCC COUNTU_LOOP				; Continue counting if carry is clear (C not set)
		BCS POLL_INSTR_TYPE			; Break if count if carry is set (C set)

DELAY	
		SUBS R7, #1					; Decrement counter
		LDREQ  R7,  DELAY_CYCLES	; Reset delay counter if count is 0
		LDREQ  R15, [R9] 			; Load next instruction to PC if count is 0, the next instruction is at the (PC before branch + 8)
		; ADDEQ  R15, R9, #0		; Load next instruction to PC if count is 0
		BNE DELAY					; Countinue counting if count is not 0
	
		
; ------- <\code memory (ROM mapped to Instruction Memory) ends>


	AREA    CONSTANTS, DATA, READONLY, ALIGN=9 
; ------- <constant memory (ROM mapped to Data Memory) begins>
; Total number of constants should not exceed 124 (128, 4 are used for peripheral pointers)
; If a variable is accessed multiple times, it is better to store the address in a register and use it rather than to load it again and again
LEDS
		DCD 0x00000C00		; Address of LEDs.
DIPS
		DCD 0x00000C04		; Address of DIP switches.
UART
		DCD 0x00000C0C		; Address of UART.
PBTN
		DCD 0x00000C08		; Address of Push buttons
NEXT_INSTR
		DCD	0x00000800		; Address of to store next instruction addr

; All constants should be declared below.
ZERO	
		DCD 0x00000000		; Zero
DELAY_CYCLES
		DCD 0x007FFFFF		; 23 bits clock cycles of delay
;DELAY_CYCLES
		;DCD 0x00000002		; 2 bits clock cycles of delay
DIPS_DATA_MASK			
		DCD 0x000000FF		; Take in only bits 7 downto 0 from DIPS switch
COUNT_INTERVAL
		DCD 0x10000000		; Count interval when bits 31 downto 16 of counter is treated as bits 7 downto 0
COUNTD_OPCODE
		DCD 0x00000001		; User input to indicate unsigned count down ("0001") BTND
COUNTU_SIGNED_OPCODE 
		DCD 0x00000002		; User input to indicate signed count up ("0010") BTNR
COUNTD_SIGNED_OPCODE
		DCD 0x00000004		; User input to indicate signed count down (0100") BTNL
COUNTU_OPCODE
		DCD 0x00000008		; User input to indicate unsigned count up ("1000") BTNU
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (REF_ADDR mapped to Data Memory) begins>
; All variables should be declared here. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it.
; Note : Reuse variables / memory if your total REF_ADDR usage exceeds 128
		
; Rest of the variables

; ------- <variable memory (REF_ADDR mapped to Data Memory) ends>
		END
		
		