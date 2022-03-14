                                                                         ; mul index r0
                                                                         ; SUM = r6 (uses r6 for sum)
                                                                         ; for I = 0 to LENGTH - 1 do (uses r1 for I)
                                                                         ; SUM = SUM + (ISBN[I]*mul_index) (uses r3 for address of ISBN[I])
                                                                         ; end for
                                                                         ; result = SUM % 11
                                                                         ; d1 = 11 - result
                                                                         ; final result (d1)= r8

	PRESERVE8
	
		
	AREA RESET, DATA, READONLY
	EXPORT __Vectors
__Vectors
	DCD 0x20001000 
	DCD Reset_Handler 
	ALIGN

ISBN DCD  7,4,6,5,1,5,9,2,3,0						 ; ISBN number 0 for indicate the end of the ISBN
CONST EQU 11 
LENGTH DCD 10 ;ISBN length

	AREA MYCODE, CODE, READONLY
	ENTRY 								 ; Always needed to indicate where to start pgm
	EXPORT Reset_Handler
Reset_Handler

	LDR r0, LENGTH							 ; r0 the mulitiplication index set to length
	LDR r2, LENGTH
	SUB r2, r2, #1							 ; r2 contains (LENGTH-1)
	MOV r6, #0		 				       	 ; r6 sum of the multiplication set to 0
FOR_INIT 
	MOV r1, #0		          	   			 ; r1 loop counter index I set to 0
	LDR r3, =ISBN							 ; start r3 with address of first number in ISBN
FOR_CMP 
	CMP r1, r2			                                 ; compare counter and (LENGTH-1)
	BGT END_FOR			                                 ; drop out of loop if I < (LENGTH-1)
	LDRB r4, [r3]		                                         ; load r4 with ISBN[I] then walk r3 down
	MUL r5, r4, r0		                                         ;multipliy ISBN[i] with its index Ex: d10 * 5
	ADD r6, r6, r5		                                         ; update sum with ISBN[I] * dindex
					
	ADD r1, r1, #1		                                         ; increment I
	ADD r3, #4 		                    	                 ; increment address
	SUB r0, r0, #1		                                         ; decrement multiplication index
	B FOR_CMP
END_FOR
	
MOD CMP r6, #CONST						         ;loop to find the mod of the result by subtracting 11 until it reach number below 11
	BLT END_MOD
	SUB r6, r6, #CONST                                               ; update the subtraction 
	B MOD
END_MOD
	RSB r8, r6, #CONST                                               ; reverse subtract to find the final value which stored in r8
STOP 
	B STOP
	END
