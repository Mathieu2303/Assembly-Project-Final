.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ SECONDS_PAUSE, 5
.equ RED_PIN, 25    //  Physical 37
.equ YELLOW_PIN, 24  // Physical 35
.equ GREEN_PIN, 23  //  Physical 33
.equ RED_WALKING_PIN, 29   // Physical 40
.equ GREEN_WALKING_PIN, 28  //Physical 38
.equ STP_PIN, 27	        //Physical 36

.align 4
.text
.global main

main:


	push {lr}
	bl wiringPiSetup             

	mov r0, #STP_PIN
	bl setPinInput		       

	mov r0, #RED_PIN
	bl setPinOutput		           
	bl pinOff		                 

	mov r0, #YELLOW_PIN
	bl setPinOutput		          
	bl pinOff		                 

	mov r0, #GREEN_PIN
	bl setPinOutput		           
	bl pinOff		                 

	mov r0, #GREEN_WALKING_PIN
	bl setPinOutput		           
	bl pinOff		                 

	mov r0, # RED_WALKING_PIN
	bl setPinOutput		           
	bl pinOff		                 

loop:

	mov r0, #RED_WALKING_PIN
	bl pinOn		      

	mov r1, #GREEN_PIN   
	bl action

	mov r0, #RED_WALKING_PIN
	bl pinOff		                 

	mov r0, #GREEN_PIN
	bl pinOff		                 

	mov r0, #RED_PIN
	bl pinOn		                 

	mov r0, #GREEN_WALKING_PIN
	bl pinOn		                 

	ldr r0, =10000
	bl delay		                 

end1_loop:
	mov r0, #RED_PIN
	bl pinOff		                 

	mov r0, #GREEN_PIN
	bl pinOff		                 

	bl blinkLights	             

second_loop:
	mov r0, #GREEN_PIN
	bl pinOn		                 

	mov r0, #RED_WALKING_PIN
	bl pinOn		                 

	ldr r0, =10000
	bl delay

	mov r0, #GREEN_PIN
	bl pinOff                    

	mov r0, #RED_WALKING_PIN
	bl pinOff                    

	mov r0, #GREEN_PIN
	bl pinOff                    

	mov r0, #RED_WALKING_PIN
	bl pinOff                    

	mov r0, #0	  	             
	pop {pc}

setPinInput:
	push {lr}
	mov r1, #INPUT
	bl pinMode
	pop {pc}


setPinOutput:
	push {lr}
	mov r1, #OUTPUT
	bl pinMode
	pop {pc}


pinOn:
	push {lr}
	mov r1, #HIGH
	bl digitalWrite
	pop {pc}



pinOff:
	push {lr}
	mov r1, #LOW
	bl digitalWrite
	pop {pc}



readStartButton:
	push {lr}
	mov r0, #STP_PIN
	bl digitalRead
	pop {pc}


action:
        push {r4, lr}
        mov r4, r1
        bl pinOff
        mov r0, r4
        bl pinOn
do_whl:
        bl readStartButton
        cmp r0, #HIGH
        beq complete
        blt do_whl
        mov r0, #0
blinkLights:
        push {r4, lr}
        mov r4, #7
LightsLoop:
        cmp r4, #0
        beq second_loop

        mov r0, #YELLOW_PIN
        bl pinOn

        mov r0, #GREEN_WALKING_PIN
        bl pinOn

        mov r0, #1000
        bl delay

        mov r0, #YELLOW_PIN
        bl pinOff

        mov r0, #GREEN_WALKING_PIN
        bl pinOff

        mov r0, #1000
        bl delay

        sub r4, #1
        bal LightsLoop
complete:
      pop {r4, pc}
