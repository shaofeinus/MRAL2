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
		LDR	 R12, DIPS  		; load address of DIP switches. DO NOT use pseudo-instructions
		LDR  R11, LEDS  		; load address of LEDs
		LDR  R10, PBTN  		; load address of PBTN
		LDR  R9,  ZERO			; load address of UART
		LDR  R8,  REF_ADDR		; load reference address
		LDR  R7,  DIPS_ADDR_MASK
		LDR  R6,  DIPS_DATA_MASK  
		; R1 constains scratch work data
		; R2 contains the memory address for memory instructions
		; R3 contains data to be stored or loaded for memory instructions (Rd)
		

LOAD_INPUTS		
		LDR  R1, [R12]				; Read input from DIPS
		AND  R2, R1, R7				; Mask bits 31:8 of DIPS, to extract base address for memory instructions
		ADD  R2, R8					; Add reference address to base address, so that positve and negative offsets (of 128 bits) to (reference adrress + base address) is still be within the RAM range
		AND  R3, R1, R6				; Mask bits 31:16 and 7:0 of DIPS,
		ADD  R3, R9, R3, LSR #8		; and shift right by 8 bits, to extract data to be stored in memory
		
POLL_INSTR_TYPE
		LDR	 R4, [R10]					; Read instr type from PBTN
		LDR  R5, LDR_N_OFFSET_OPCODE	; Test for LDR_N_OFFSET_OP
		CMP  R4, R5		
		BEQ  LDR_N_OFFSET_OP
		LDR  R5, STR_P_OFFSET_OPCODE	; Test for STR_P_OFFSET_OP
		CMP  R4, R5		
		BEQ  STR_P_OFFSET_OP
		LDR  R5, STR_N_OFFSET_OPCODE	; Test for STR_N_OFFSET_OP
		CMP  R4, R5	
		BEQ  STR_N_OFFSET_OP
		LDR  R5, LDR_P_OFFSET_OPCODE	; Test for LDR_P_OFFSET_OP
		CMP  R4, R5		
		BEQ  LDR_P_OFFSET_OP
		B	 POLL_INSTR_TYPE			; Keep polling until a valid type is entered
	
LDR_N_OFFSET_OP	
		LDR  R3, [R2, #-16]			; Load from (reference address + base base address) - 4	
		STR  R3, [R11]				; Display loaded data on LED
		B LOAD_INPUTS
		
STR_P_OFFSET_OP	
		STR  R3, [R2, #16]			; Store to (reference address + base base address) + 4	
		STR  R3, [R11]				; Display stored data on LED
		B LOAD_INPUTS
		
STR_N_OFFSET_OP	
		STR  R3, [R2, #-16]			; Store to (reference address + base base address) - 4	
		STR  R3, [R11]				; Display stored data on LED
		B LOAD_INPUTS

LDR_P_OFFSET_OP	
		LDR  R3, [R2, #16]			; Load from (reference address + base base address) + 4	
		STR  R3, [R11]				; Display loaded data on LED
		B LOAD_INPUTS

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
ZERO
		DCD 0x00000000		; Zero
REF_ADDR
		DCD 0x00000880		; Reference address for memory instructions (0x880). 
DIPS_ADDR_MASK
		DCD 0x000000FF		; Mask the DIPS input to allow only for bits 7:0 inputs 	
DIPS_DATA_MASK
		DCD 0x0000FF00		; Mask the DIPS input to allow only for bits 15:8 inputs 
LDR_N_OFFSET_OPCODE
		DCD 0x00000001		; User input to indicate LDR with negative offset instr ("0001") BTND
STR_P_OFFSET_OPCODE 
		DCD 0x00000002		; User input to indicate STR with positive offset instr ("0010") BTNR
STR_N_OFFSET_OPCODE
		DCD 0x00000004		; User input to indicate STR with negative offset instr ("0100") BTNL
LDR_P_OFFSET_OPCODE
		DCD 0x00000008		; User input to indicate LDR with positive offset instr ("1000") BTNU
		
; ------- <constant memory (ROM mapped to Data Memory) ends>	


	AREA   VARIABLES, DATA, READWRITE, ALIGN=9
; ------- <variable memory (REF_ADDR mapped to Data Memory) begins>
; All variables should be declared here. 
; No initialization possible in this region. In other words, you should write to a location before you can read from it.
; Note : Reuse variables / memory if your total REF_ADDR usage exceeds 128
		
; Rest of the variables

; ------- <variable memory (REF_ADDR mapped to Data Memory) ends>
		END
		
		