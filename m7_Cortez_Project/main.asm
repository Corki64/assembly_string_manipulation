; @author Luis Cortez
;
;
;
; @Program Name: Module_07 Programming assignment 04
;
;
; @date - 120220181228
; @version - 120220181228
;
; @dependencies - must include Irvine32 library saved in c:\;
INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
; Excercise 1 prompt data
     promptOne BYTE "Please enter a sentence: ", 0
     promptTwo BYTE "Please enter the number of characters to delete (in hexadecimal): ", 0
     promptThree BYTE "Please enter the position from where to start deleting (in hexadecimal:) ", 0

; Exercise 2 prompts data
     promptFour BYTE "Please enter a sentence (S1) to insert: ", 0
     promptFive BYTE "Please enter a sentence (S2) in which to insert: ", 0
     promptSix BYTE "Please enter the position (P) where to insert: ", 0
;
;
     buffOne BYTE 4096 DUP(?)       ; String storage buffers. 
     buffTwo BYTE 4096 DUP(?)

     sentenceLengthOne EQU $ - buffOne
     sentenceLengthTwo EQU $ - buffTwo
     totalStringLengthOne EQU $ - totalString
     totalStringLengthTwo EQU $ - totalString2


     numberToDelete DWORD 0
     positionToDelete DWORD 0
     positionToStart DWORD 0
     totalString DB sentenceLengthOne + sentenceLengthTwo - 1 DUP (?)
     totalString2 DB sentenceLengthOne + sentenceLengthTwo - 1 DUP (?)
     finalString BYTE 1024 - 1 DUP (?)

     count = ($ - totalString)

     charToDelete DWORD ?





.code
;
;
;
;



;
;
;
main proc

     ;CALL ExerciseOne
     CALL ExerciseTwo


     invoke ExitProcess, 0
main endp

; This program will ask the user to enter a sentence. Then it will ask them for a
; number of characters to delete (in hexadecimal). It will then ask for a position to
; start deletion. It will then delete the amount of characters and given point and
; reprint the string (array).
;
;
ExerciseOne proc USES EDX ECX EAX EDI EBX    ; Saves all registers that are used / push and pop

     MOV EDX, OFFSET promptOne               ; Prompt user for input
     CALL WriteString

     MOV EDX, OFFSET buffOne                 ; Move offset to input buffer
     MOV ECX, SIZEOF buffOne                 ; Move length to ECX
     CALL ReadString                         ; Read in user input

     CALL newLine

     MOV EDX, OFFSET promptTwo               ; Prompt user for number of characters to delete in hexadecimal
     CALL WriteString
     CALL ReadHex
     MOV EBX, 0                              ; Clears the EBX register
     MOV EBX, EAX                            ; Store number to delete in var

     CALL newLine

     MOV EDX, OFFSET promptThree             ; Prompt user for position to start deleting in hexadecimal
     CALL WriteString
     CALL ReadHex
     ADD EBX, EAX                            ; Adds the number to delete with the position to start

     CALL newLine

     CLD                                     ; MOVSB direction

     MOV ESI, OFFSET buffOne                 ; Source
     MOV EDI, OFFSET buffOne                 ; Destination
     ADD ESI, EBX                            ; Moving to number to delete + position to delete
     ADD EDI, EAX                            ; Moving to position to start

     MOV ECX, SIZEOF buffOne                 ; Counter set to size of sentence
     SUB ECX, EBX                            ; Subtracting size of sentence by number to delete + position to delete
     REP MOVSB                               ; Repeating until ECX = 0

     MOV EDX, OFFSET buffOne                 ; Positioning EDX for WriteString of results
     CALL WriteString

     CALL newLine
               
     RET
ExerciseOne endp

; This program will ask the user to enter a string to insert.
; It will then prompt the user for a second string.
; Finally it will ask the user at what point they would
; like to insert string one (in hexadecimal).
; It will then print the results to console.
;
;
ExerciseTwo proc USES EDX ECX EAX EDI EBX    ; Saves all registers that are used / push and pop

     MOV EDX, OFFSET promptFour              ; Prompt user for input - sentence one
     CALL WriteString
     
     MOV EDX, OFFSET buffOne                 ; Move offset to input buffer
     MOV ECX, SIZEOF buffOne                 ; Move length to ECX
     CALL ReadString                         ; Read in user input
     PUSH EAX

     CALL newLine

     MOV EDX, OFFSET promptFive              ; Prompt user for input - sentence two
     CALL WriteString

     MOV EDX, OFFSET buffTwo                 ; Move offset to input buffer
     MOV ECX, SIZEOF buffTwo                 ; Move length to ECX
     CALL ReadString                         ; Read in user input
     PUSH EAX

     CALL newLine

     MOV EDX, OFFSET promptSix
     CALL WriteString

     CALL ReadHex                            ; Read in as a hexadecimal value
     MOV positionToStart, EAX                ; Store start position in EAX


     CLD                                     ; MOVSB direction
     MOV ESI, OFFSET buffTwo                 ; Copies sentence two up until start position
     MOV ECX, SIZEOF buffTwo
     MOV EDI, OFFSET totalString
     REP MOVSB

     CALL newLine
     
     CLD
     MOV ESI, OFFSET buffOne                 ; Copies sentence one onto sentence two
     MOV ECX, SIZEOF buffOne
     MOV EDI, offset totalString
     ADD EDI, positionToStart
     REP MOVSB

     CLD
     MOV ESI, OFFSET buffTwo                 ; Move offset to sentence two
     ADD ESI, EAX
     POP EBX
     POP ECX
     MOV EDI, OFFSET totalString
     ADD EDI, LENGTHOF totalString
     ADD ECX, EBX
     ADD ECX, LENGTHOF totalString
     REP MOVSB
     
     
     
     MOV EDX, OFFSET totalString             ; Print statements - I had trouble making my strings longer
     CALL WriteString

     MOV EDX, OFFSET totalString2            ; Overfill spilled onto this string just printed it
     CALL WriteString
  
     RET
ExerciseTwo endp


; Simple method to clean up code.
newLine proc USES EAX                        ; Saves all registers that are used / push and pop

     ;PUSH EAX                               ; Example of using PUSH without USES

     MOV AL, 0Ah    		               ; Quick newline method to stop repeating myself.
     CALL WriteChar
     MOV AL, 0Dh
     CALL WriteChar

     ;POP EAX                                ; Example of using POP without USES
     RET
newLine endp


end main