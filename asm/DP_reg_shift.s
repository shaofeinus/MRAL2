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
;>>> Also note that you do a CPU reset in the simulator, the RAM (memory storing variables) in the simulator might not get reset.
	AREA    MYCODE, CODE, READONLY, ALIGN=9 
		ENTRY
	  
; ------- <code memory (ROM mapped to Instruction Memory) begins>
; Total number of instructions should not exceed 128
		LDR	 R12, DIPS  		; load address of DIP switches. DO NOT use pseudo-instructions
		LDR  R11, LEDS  		; load address of LEDs
		LDR  R10, PBTN  		; load address of PBTN
		LDR  R3,  BASE			; load base number for DP instructions
		; R2 contains Src2 of arithmetic operations
		; R1 contains scratch work data

LOAD_OPERAND2		
		LDR  R2, [R12]		; Read Src2 from DIPS
		
POLL_INSTR_TYPE
		LDR	 R4, [R10]		; Read instr type from PBTN
		LDR  R5, LSL_OPCODE	; Test for LSL_OP
		CMP  R4, R5		
		BEQ  LSL_OP
		LDR  R5, LSR_OPCODE	; Test for LSR_OP
		CMP  R4, R5		
		BEQ  LSR_OP
		LDR  R5, ASR_OPCODE	; Test for ASR_OP
		CMP  R4, R5	
		BEQ  ASR_OP
		LDR  R5, ROR_OPCODE	; Test for ROR_OP
		CMP  R4, R5		
		BEQ  ROR_OP
		B	 POLL_INSTR_TYPE; Keep polling until a valid type is entered
	
LSL_OP	
		ADD  R1, R3, R2, LSL #1		; Do LSL of 1 bit
		STR  R1, [R11]				; Display result on LED
		B LOAD_OPERAND2
		
; -- In this LSR demo, 
; -- input on DIPS corresponds to bits 31:16 of actual data being processed, while
; -- output on LED corresponds to bits 31:24 of actual data being processed
; -- so as to demonstrate that LSR redsults in left-most bits being 0 after shift
LSR_OP	
		ADD  R1, R3, R2, LSL #16	; Align bit 15:0 of Src2 (DIPS) to bit 31:16
		ADD  R1, R3, R1, LSR #1		; Do the actual LSR of 1 bit with the aligned Src2
		ADD	 R1, R3, R1, LSR #24	; Align bit 31:24 of result to bit 7:0 to be displayed on LED
		STR  R1, [R11]				; Display result on LED
		B LOAD_OPERAND2
		
; -- In this ASR demo, 
; -- input on DIPS corresponds to bits 31:16 of actual data being processed, while
; -- output on LED corresponds to bits 31:24 of actual data being processed
; -- so as to demonstrate the ability of ASR to preserve the MSB before the shift
ASR_OP	
		ADD  R1, R3, R2, LSL #16	; Align bit 15:0 of Src2 (DIPS) to bit 31:16
		ADD  R1, R3, R1, ASR #2		; Do the actual ASR of 2 bits with the aligned Src2
		ADD	 R1, R3, R1, LSR #24	; Align bit 31:24 of result to bit 7:0 to be displayed on LED
		STR  R1, [R11]				; Display result on LED
		B LOAD_OPERAND2

; -- In this ROR demo, 
; -- input on DIPS corresponds to bits 15:0 of actual data being processed, while
; -- output on LED corresponds to bits 31:24 of actual data being processed,
; -- so as to demonstrate the ability of ROR to rotate the right-most bits to the left-most bits
ROR_OP	
		ADD  R1, R3, R2, ROR #4		; Do ROR of 4 bits
		ADD  R1, R3, R1, LSR #24	; Align bit 31:24 of result to bit 7:0 to be displayed on LED
		STR  R1, [R11]				; Display result on LED
		B LOAD_OPERAND2

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

; All constants should be declared below.
BASE
		DCD 0x00000000		; Base number for arithmetic operations
ASR_OPCODE
		DCD 0x00000001		; User input to indicate LSL instr ("0001") BTND
LSR_OPCODE 
		DCD 0x00000002		; User input to indicate LSR instr ("0010") BTNR
LSL_OPCODE
		DCD 0x00000004		; User input to indicate ASR instr ("0100") BTNL
ROR_OPCODE
		DCD 0x00000008		; User input to indicate ROR instr ("1000") BTNU
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (RAM mapped to Data Memory) begins>
; All variables should be declared here. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it.
; Note : Reuse variables / memory if your total RAM usage exceeds 128
		
; Rest of the variables

; ------- <variable memory (RAM mapped to Data Memory) ends>
		END
		
		