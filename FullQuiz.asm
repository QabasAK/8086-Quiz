; -------------------------------
; multi-segment MASM template
; -------------------------------

data segment           
    
    ; --- Prompts ---
    EnterUsername   db "Enter your username: $"
    EnterPassword   db "Enter your password: $"
    
    UsernameBuffer    db 10, 0, 10 dup(0)
    PasswordBuffer    db 10, 0, 10 dup(0) 
    
    UsernameInput    db 11 dup(0)
    PasswordInput    db 11 dup(0)     

    ; --- Credential Database ---

    User1 db "Ahmad", 0
    Pass1 db "Dad00", 0
    
    User2 db "Azhar", 0
    Pass2 db "Mom01", 0
    
    User3 db "Alaa", 0
    Pass3 db "Bro10", 0

    ; --- Messages ---
    crrctCred   db "Correct Credentials! Welcome : )$"
    wrngCred    db "Invalid Information >:( $"  
    
    ; --- Topic : Computational Complexity ---  
    Crrct db "Correct Answer! :D$"
    Wrng db "Wrong Answer :($"  
    
    
    Questions db 1, 2, 3, 4, 5
    Seed db 1
    
    ; --- Question 1 ---
    Q1  db "Q1: What does it mean for a problem to be in class P?$"
    Q1A db "A. It has a polynomial-time solution$"
    Q1B db "B. It can only be solved probabilistically$"
    Q1C db "C. It cannot be solved by computers$"
    Q1D db "D. It takes infinite time to solve$"
    Q1SolC db "A", 0  
    Q1SolS db "a", 0
    Q1In db 2Ah, 0, 2Ah dup(0) 
    Q1UserAnswer db 3 dup(0)
    
    ; --- Question 2 ---
    Q2  db "Q2: Which of the following is a decision problem?$"
    Q2A db "A. Sorting a list$"
    Q2B db "B. Finding the shortest path$"
    Q2C db "C. Determining if a graph has a Hamiltonian cycle$"
    Q2D db "D. Calculating Pi to 1000 digits$"
    Q2SolC db "C", 0 
    Q2SolS db "c", 0
    Q2In db 2Ah, 0, 2Ah dup(0) 
    Q2UserAnswer db 3 dup(0)
    
    ; --- Question 3 ---
    Q3  db "Q3: Every NP problem is also in P.$"
    Q3A db "A. Always True$"
    Q3B db "B. Always False$"
    Q3C db "C. True if P != NP$"
    Q3D db "D. True if P = NP$"
    Q3SolC db "D", 0 
    Q3SolS db "d", 0
    Q3In db 2Ah, 0, 2Ah dup(0) 
    Q3UserAnswer db 3 dup(0)
    
     ; --- Question 4 ---
    Q4  db "Q4: What does a reduction do? (Purpose of Reduction)$"
    Q4A db "A. To compress data$"
    Q4B db "B. To speed up algorithms$"
    Q4C db "C. To transform one problem into another$"
    Q4D db "D. To lower time complexity of a problem$"
    Q4SolC db "C", 0 
    Q4SolS db "c", 0
    Q4In db 2Ah, 0, 2Ah dup(0) 
    Q4UserAnswer db 3 dup(0)           

     ; --- Question 5 ---    
    Q5  db "Q5: Which takes longer: sorting 1000 items or making 1000 sandwiches by hand?$"
    Q5A db "A. Any Sorting Algorithm$"
    Q5B db "B. Sandwiches$"
    Q5C db "C. Same time$"
    Q5D db "D. Depends on hunger level$"
    Q5SolC db "A", 0 
    Q5SolS db "a", 0
    Q5In db 2Ah, 0, 2Ah dup(0) 
    Q5UserAnswer db 3 dup(0)
    
     ; --- Score Output --- 
    EndQuiz db "Your Score ==> $"   
    Score db 0
    Del db "/5$" 
    
     ; --- Timer Data --- 
    timer dw ?
    countdown dw ?
    time_msg db 'Time left: $'
    time_out db 0  
    
     ; --- Store Scores --- 
    AhmadScore db 0
    AzharScore db 0
    AlaaScore db 0
    
    ; --- Leaderboard Display Strings ---
    LBHeader   db 13,10,'=== Top Scores ===',13,10,'$'
    LB1        db '1st: $'
    LB2        db '2nd: $'
    LB3        db '3rd: $'
    LBScore    db '/5',13,10,'$' 
    
    Display_User1 db "Ahmad   $"
    Display_User2 db "Azhar   $"
    Display_User3 db "Alaa    $" 
    
data ends

       
stack segment
    
    dw 128 dup(0)  
    
stack ends
 
 
code segment
start:
    ; --- Initialize DS/ES ---
    mov     ax, data
    mov     ds, ax
    mov     es, ax  
    
    ; --- Initialize Scores ---
    mov     al, 0
    mov     [AhmadScore], al
    mov     [AzharScore],  al
    mov     [AlaaScore], al
    
    ; --- Authentication 3 Attempts ---
    mov     cx, 3
Authen:
    push    cx 
    
    call    ReadCredentials  
    call    LoginAuthentication 
    
    cmp     bl, 0
    je      SUCCESS  
      
    loop    Authen    
    jmp     FAIL
    
    ; --- Start When Authenticated ---
StartQuiz: 
    mov     si, offset Questions 
    mov     Score, 0  
    mov     cx, 5      
    call    Newline  
    
ProcessQuestions: 
    ; --- Determine Order of Questions ---
    mov     al, [si]    
     
    cmp     al, 1
    je      CallQ1 
    
    cmp     al, 2
    je      CallQ2
    
    cmp     al, 3
    je      CallQ3
    
    cmp     al, 4
    je      CallQ4
    
    cmp     al, 5
    je      CallQ5   
    
    ; --- Call Question in Order ---
    
CallQ1:
    call    SolveQuestion1                                                                                                             
    jmp     UpdateScore
    
CallQ2:
    call    SolveQuestion2
    jmp     UpdateScore
    
CallQ3:
    call    SolveQuestion3
    jmp     UpdateScore
    
CallQ4:
    call    SolveQuestion4
    jmp     UpdateScore
    
CallQ5:
    call    SolveQuestion5
    
    ; --- Score + 1 if Correct ---
UpdateScore:
    add     Score, bl
    call    Newline 
    
NextQuestion:
    inc     si
    loop    ProcessQuestions
    
    ; --- Display End of Quiz ---
    lea     dx, EndQuiz
    mov     ah, 9
    int     21h 
    
    ; --- Display End of Quiz ---
    mov     dl, Score      
    add     dl, 30h 
    mov     ah, 02h 
    int     21h    
    lea     dx, Del    
    mov     ah, 9
    int     21h 
    
    ; --- Space Between Sessions ---
    call    NewLine 
    call    Newline
    call    Newline
    
    call    PushScores
    pop     cx  
    loop    Authen  
    jmp     ShowEndLeaderboard                                             
    
    ; --- Incorrect Credentials ---
FAIL:
    lea     dx, wrngCred
    mov     ah, 9
    int     21h
    call    NewLine
    jmp     DONE
    
    ; --- Correct Credentials ---
SUCCESS:
    lea     dx, crrctCred
    mov     ah, 9
    int     21h
    call    NewLine  
    
    call    calculate_timer
    mov     timer, ax
    
    ; --- Randomization Setup ---
    mov     ah, 00h
    int     1ah 
    ; --- BIOS System Clock ---
    mov     seed, dl
    
    cmp     seed, 0
    jne     SeedValid
    mov     Seed, 1  
    
SeedValid:
    call    Shuffle    
    jmp     StartQuiz 

    ; --- Show Leaderboard if Successful ---    
ShowEndLeaderboard:
    call    ShowLeaderboard  

DONE:
    ; --- Return Control to OS --- 
    mov     ax, 4C00h
    int     21h



; --- read credentials ---    
ReadCredentials proc
    ; --- read username ---
    lea     dx, EnterUsername
    mov     ah, 9
    int     21h

    lea     dx, UsernameBuffer
    mov     ah, 0Ah
    int     21h
    
    call    NewLine   
    
    lea     si, UsernameBuffer + 2 
    lea     di, UsernameInput
    call    CopyInputTo
    
    
    ; --- read password ---
    lea     dx, EnterPassword
    mov     ah, 9
    int     21h

    lea     dx, PasswordBuffer
    mov     ah, 0Ah
    int     21h
    
    call    NewLine 
    
    lea     si, PasswordBuffer + 2 
    lea     di, PasswordInput
    call    CopyInputTo
    
    ret
ReadCredentials endp  


; --- Authenticate Input ---         
LoginAuthentication proc
    mov     bl, 1
CheckUser1:    
    lea     si, UsernameInput
    lea     di, User1      
    
    call    CompareStrings
    cmp     ax, 0
    jnz     CheckUser2  
    
    lea     si, PasswordInput
    lea     di, Pass1    
    
    call    CompareStrings
    cmp     ax, 0     
    jz      Authen_Success  
    jmp     Authen_Done

CheckUser2:
    lea     si, UsernameInput
    lea     di, User2  
    
    call    CompareStrings
    cmp     ax, 0
    jnz     CheckUser3  
    
    lea     si, PasswordInput
    lea     di, Pass2   
    
    call    CompareStrings
    cmp     ax, 0
    jz      Authen_Success 
    jmp     Authen_Done

CheckUser3:
    lea     si, UsernameInput
    lea     di, User3   
    
    call    CompareStrings
    cmp     ax, 0
    jnz     Authen_Done   
    
    lea     si, PasswordInput
    lea     di, Pass3 
    
    call    CompareStrings
    cmp     ax, 0
    jz      Authen_Success  
    
    Authen_Done:
    ret
    
    Authen_Success:
    mov     bl, 0
    ret
LoginAuthentication endp  


; --- Track Scores in Memory ---  
PushScores proc 
    
    ; --- Determine User ---
    lea     si, UsernameInput
    lea     di, User1 
    
    call    CompareStrings
    cmp     ax, 0
    je      UpdateAhmad
    
    lea     si, UsernameInput
    lea     di, User2  
    
    call    CompareStrings
    cmp     ax, 0
    je      UpdateAzhar
    
    lea     si, UsernameInput
    lea     di, User3  
    
    call    CompareStrings
    cmp     ax, 0
    je      UpdateAlaa  
    
    ; --- No match ---
    ret
    
    ; --- Comparisons Ensure Highest Score --- 
    ; --- Player 1 ---
UpdateAhmad:
    mov     al, [Score]
    cmp     [AhmadScore], al
    jb      SetAhmad
    ret
SetAhmad:   
    mov     [AhmadScore], al
    ret
   
    ; --- Player 2 ---
UpdateAzhar:
    mov     al, [Score]
    cmp     [AzharScore], al
    jb      SetAzhar
    ret
SetAzhar:
    mov     [AzharScore], al
    ret
    
    ; --- Player 3 ---
UpdateAlaa:
    mov     al, [Score]
    cmp     [AlaaScore], al
    jb      SetAlaa
    ret
SetAlaa:
    mov     [AlaaScore], al
    ret
PushScores endp


; --- Display Leaderboard ---
ShowLeaderboard proc   
    
    ; --- Display Header ---
    lea     dx, LBHeader
    mov     ah, 9
    int     21h
    
    ; --- Compare All Scores  ---
    mov     bl, [AhmadScore]
    mov     bh, [AzharScore]
    mov     cl, [AlaaScore]
    
    ; --- Determine 1st place ---
    cmp     bl, bh
    jae     CheckAhmadFirst
    jmp     CheckAzharFirst
    
CheckAhmadFirst:
    cmp     bl, cl
    jae     ShowAhmadFirst
    jmp     ShowAlaaFirst
    
CheckAzharFirst:
    cmp     bh, cl
    jae     ShowAzharFirst
    jmp     ShowAlaaFirst
    
CheckAlaaFirst:
    cmp     cl, bh
    jae     ShowAlaaFirst
    jmp     ShowAzharFirst
    
ShowAhmadFirst:
    ; --- 1st place ---
    lea     dx, LB1
    mov     ah, 9
    int     21h 
    
    lea     dx, Display_User1
    int     21h
    mov     dl, [AhmadScore]
    add     dl, 30h
    mov     ah, 2
    int     21h 
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    
    ; --- 2nd place ---
    cmp     bh, cl
    ja      ShowAzharSecond
    jmp     ShowAlaaSecond
    
ShowAzharFirst:
    ; --- 1st place ---
    lea     dx, LB1
    mov     ah, 9
    int     21h  
    
    lea     dx, Display_User2
    int     21h
    mov     dl, [AzharScore]
    add     dl, 30h
    mov     ah, 2
    int     21h  
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    
    ; --- 2nd place ---
    cmp     bl, cl
    ja      ShowAhmadSecond
    jmp     ShowAlaaSecond
    
ShowAlaaFirst:
    ; --- 1st place ---
    lea     dx, LB1
    mov     ah, 9
    int     21h
    
    lea     dx, Display_User3
    int     21h
    mov     dl, [AlaaScore]
    add     dl, 30h
    mov     ah, 2
    int     21h   
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    
    ; --- 2nd place ---
    cmp     bl, bh
    ja      ShowAhmadSecond
    jmp     ShowAzharSecond 
    
ShowAhmadSecond:   
    ; --- 2nd place ---
    lea     dx, LB2
    mov     ah, 9
    int     21h 
    
    lea     dx, Display_User1
    int     21h
    mov     dl, [AhmadScore]
    add     dl, 30h
    mov     ah, 2
    int     21h 
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    
    ; --- 3rd place ---
    cmp     cl, bh
    ja      ShowAzharThird
    jmp     ShowAlaaThird

ShowAzharSecond:
    ; --- 2st place ---
    lea     dx, LB2
    mov     ah, 9
    int     21h
    
    lea     dx, Display_User2
    int     21h
    mov     dl, [AzharScore]
    add     dl, 30h
    mov     ah, 2
    int     21h 
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    
    ; --- 3rd place ---
    cmp     cl, bl
    ja      ShowAhmadThird
    jmp     ShowAlaaThird

ShowAlaaSecond:
    ; --- 2nd place ---
    lea     dx, LB2
    mov     ah, 9
    int     21h  
    
    lea     dx, Display_User3
    int     21h
    mov     dl, [AlaaScore]
    add     dl, 30h
    mov     ah, 2
    int     21h
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    
    ; --- 3rd place ---
    cmp     bh, bl
    ja      ShowAhmadThird
    jmp     ShowAzharThird  

ShowAhmadThird: 
    ; --- 3rd place ---
    lea     dx, LB3
    mov     ah, 9
    int     21h   
    
    lea     dx, Display_User1
    int     21h
    mov     dl, [AhmadScore]
    add     dl, 30h
    mov     ah, 2
    int     21h 
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    jmp     DoneDisplay

ShowAzharThird: 
    ; --- 3rd place ---
    lea     dx, LB3
    mov     ah, 9
    int     21h  
    
    lea     dx, Display_User2
    int     21h
    mov     dl, [AzharScore]
    add     dl, 30h
    mov     ah, 2
    int     21h 
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h
    jmp     DoneDisplay

ShowAlaaThird:
    ; --- 3rd place ---
    lea     dx, LB3
    mov     ah, 9
    int     21h   
    
    lea     dx, Display_User3
    int     21h
    mov     dl, [AlaaScore]
    add     dl, 30h
    mov     ah, 2
    int     21h  
    
    lea     dx, LBScore
    mov     ah, 9
    int     21h  

DoneDisplay:
    ret
ShowLeaderboard endp


; --- Timer = 6 * 2 = 12 secs ---
calculate_timer proc
    mov     ax, 12
    ret
calculate_timer endp



; --- Display Timer ---
show_timer proc
    ; --- Save Cursor Position ---
    push    ax
    push    dx
    
    ; --- Move cursor to beginning of line ---
    mov     ah, 02h
    mov     dl, 0Dh
    int     21h
    
    ; --- Show time message --- 
    lea     dx, time_msg
    mov     ah, 09h
    int     21h

    ; --- Convert to ASCII ---
    mov     ax, countdown  
    ; --- Convert Decimal to BCD (tens & units) ---
    aam      
    ; --- ah + 30h and al + 30h ---
    add     ax, 3030h
    push    ax

    ; --- Display tens digit ---
    mov     dl, ah
    mov     ah, 02h
    int     21h

    ; --- Display units digit ---
    pop     dx
    mov     dh, 0
    int     21h
    
    pop     dx
    pop     ax
    ret
show_timer endp



; --- Second Delay for Timer ---
delay_1sec proc
    push    cx
    push    dx   
    
    ; --- 0F4240h = 1,000,000 microseconds ---
    mov     cx, 000Fh 
    mov     dx, 4240h
    
    ; --- BIOS Wait function ---
    mov     ah, 86h
    int     15h  
    
    pop     dx
    pop     cx
    ret
delay_1sec endp
         


; --- Shuffle Helper Function ---         
Shuffle proc
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    push    di

    mov     cx, 5           
ShuffleLoop:
    ; --- Generate random index (0-4) ---
    mov     al, Seed
    mov     bl, 5            
    mov     ah, 0            
    mov     dl, 4            
    mul     dl              
    add     al, 3          
    div     bl            
    mov     dl, ah          

    ; --- Swap logic ---
    lea     si, Questions
    cmp     dl, 0  
    je      Swap0 
    
    cmp     dl, 1
    je      Swap1 
    
    cmp     dl, 2
    je      Swap2 
    
    cmp     dl, 3
    je      Swap3 
    
    cmp     dl, 4
    je      Swap4

Swap0:
    mov     al, [si]
    mov     bl, [si+1] 
    
    mov     [si], bl
    mov     [si+1], al
    jmp     DoneSwap 
    
Swap1:
    mov     al, [si+1]
    mov     bl, [si+2] 
    
    mov     [si+1], bl
    mov     [si+2], al
    jmp     DoneSwap 
    
Swap2:
    mov     al, [si+2]
    mov     bl, [si+3] 
    
    mov     [si+2], bl
    mov     [si+3], al
    jmp     DoneSwap
    
Swap3:
    mov     al, [si+3]
    mov     bl, [si+4] 
    
    mov     [si+3], bl
    mov     [si+4], al
    jmp     DoneSwap  
    
Swap4:
    mov     al, [si+4]
    mov     bl, [si]  
    
    mov     [si+4], bl
    mov     [si], al

DoneSwap:
    ; --- Update Seed ---
    mov     al, Seed
    mov     bl, 7
    mul     bl
    add     al, 3
    mov     Seed, al

    loop    ShuffleLoop   

    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
Shuffle endp        
         


; --- Solve Questions ---         
SolveQuestion1 proc
    push    dx
    push    ax  
    push    si
    push    di 
    
    call    calculate_timer
    mov     countdown, ax
    mov     time_out, 0
    
    ; --- Display Questions and Options ---  
    lea     dx, Q1 
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q1A
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q1B
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q1C
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q1D
    mov     ah, 9
    int     21h 
    call    Newline   
    
    ; --- Start Timer ---
TimerLoop:
    call    show_timer
    call    delay_1sec
    dec     countdown
    jz      TimeExpired
    
    ; --- Check for Keystroke ---
    mov     ah, 01h      
    int     16h  
    ; --- No key pressed, continue ---
    jz      TimerLoop     

    ; --- Read the key and process ---  
    call    Newline
    mov     ah, 00h
    int     16h  
    
    ; --- Store Character ---
    mov     [Q1UserAnswer], al  
    mov     byte ptr [Q1UserAnswer+1], 0 

    ; --- Echo the input ---
    mov     ah, 02h
    mov     dl, al
    int     21h
     
    call    Newline   
    jmp     ProcessAnswer  
    
TimeExpired:
    mov     time_out, 1
    call    Newline
    jmp     Q1WrongAnswer 
    
ProcessAnswer: 
    ; --- Upper Case Input ---     
    lea     si, Q1SolC
    lea     di, Q1UserAnswer 
    
    call    CompareChar
    cmp     ax, 0
    je      Q1CorrectAnswer 
    
    ; --- Lower Case Input ---
    lea     si, Q1SolS 
    lea     di, Q1UserAnswer  
    
    call    CompareChar
    cmp     ax, 0 
    
    je      Q1CorrectAnswer 
    jmp     Q1WrongAnswer
    
Q1WrongAnswer:
    lea     dx, Wrng
    mov     ah, 9
    int     21h 
    
    call    Newline  
    call    Peep
     
    mov     bl, 0  
    jmp     EndQuestion 
    
Q1CorrectAnswer:
    lea     dx, Crrct
    mov     ah, 9
    int     21h
     
    call    Newline  
    mov     bl, 1    
    
EndQuestion:
    pop     di
    pop     si
    pop     ax
    pop     dx
    ret
SolveQuestion1 endp 


SolveQuestion2 proc
    push    dx
    push    ax  
    push    si
    push    di 
    
    call    calculate_timer
    mov     countdown, ax
    mov     time_out, 0
    
    ; --- Display Questions and Options ---  
    lea     dx, Q2 
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q2A
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q2B
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q2C
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q2D
    mov     ah, 9
    int     21h 
    call    Newline   
    
    ; --- Start Timer ---
TimerLoop2:
    call    show_timer
    call    delay_1sec
    dec     countdown
    jz      TimeExpired2
    
    ; --- Check for Keystroke ---
    mov     ah, 01h      
    int     16h  
    ; --- No key pressed, continue ---
    jz      TimerLoop2     
    
    ; --- Read the key and process ---  
    call    Newline
    mov     ah, 00h
    int     16h  
    
    ; --- Store Character ---
    mov     [Q2UserAnswer], al  
    mov     byte ptr [Q2UserAnswer+1], 0 

    ; --- Echo the input ---
    mov     ah, 02h
    mov     dl, al
    int     21h
     
    call    Newline   
    jmp     ProcessAnswer2  
    
TimeExpired2:
    mov     time_out, 1
    call    Newline
    jmp     Q2WrongAnswer 
    
ProcessAnswer2: 
    ; --- Upper Case Input ---     
    lea     si, Q2SolC
    lea     di, Q2UserAnswer 
    
    call    CompareChar
    cmp     ax, 0
    je      Q2CorrectAnswer 
    
    ; --- Lower Case Input ---
    lea     si, Q2SolS 
    lea     di, Q2UserAnswer  
    
    call    CompareChar
    cmp     ax, 0 
    
    je      Q2CorrectAnswer 
    jmp     Q2WrongAnswer
    
Q2WrongAnswer:
    lea     dx, Wrng
    mov     ah, 9
    int     21h 
    
    call    Newline  
    call    Peep
     
    mov     bl, 0  
    jmp     EndQuestion2 
    
Q2CorrectAnswer:
    lea     dx, Crrct
    mov     ah, 9
    int     21h
     
    call    Newline  
    mov     bl, 1    
    
EndQuestion2:
    pop     di
    pop     si
    pop     ax
    pop     dx
    ret
SolveQuestion2 endp


SolveQuestion3 proc
    push    dx
    push    ax  
    push    si
    push    di 
    
    call    calculate_timer
    mov     countdown, ax
    mov     time_out, 0
    
    ; --- Display Questions and Options ---  
    lea     dx, Q3 
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q3A
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q3B
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q3C
    mov     ah, 9
    int     21h 
    call    Newline
    
    lea     dx, Q3D
    mov     ah, 9
    int     21h 
    call    Newline   
    
    ; --- Start Timer ---
TimerLoop3:
    call    show_timer
    call    delay_1sec
    dec     countdown
    jz      TimeExpired3
    
    ; --- Check for Keystroke ---
    mov     ah, 01h      
    int     16h  
    ; --- No key pressed, continue ---
    jz      TimerLoop3     
    
    ; --- Read the key and process ---  
    call    Newline
    mov     ah, 00h
    int     16h  
    
    ; --- Store Character ---
    mov     [Q3UserAnswer], al  
    mov     byte ptr [Q3UserAnswer+1], 0 

    ; --- Echo the input ---
    mov     ah, 02h
    mov     dl, al
    int     21h
     
    call    Newline   
    jmp     ProcessAnswer3  
    
TimeExpired3:
    mov     time_out, 1
    call    Newline
    jmp     Q3WrongAnswer 
    
ProcessAnswer3: 
    ; --- Upper Case Input ---     
    lea     si, Q3SolC
    lea     di, Q3UserAnswer 
    
    call    CompareChar
    cmp     ax, 0
    je      Q3CorrectAnswer 
    
    ; --- Lower Case Input ---
    lea     si, Q3SolS 
    lea     di, Q3UserAnswer  
    
    call    CompareChar
    cmp     ax, 0 
    
    je      Q3CorrectAnswer 
    jmp     Q3WrongAnswer
    
Q3WrongAnswer:
    lea     dx, Wrng
    mov     ah, 9
    int     21h 
    
    call    Newline  
    call    Peep
     
    mov     bl, 0  
    jmp     EndQuestion3 
    
Q3CorrectAnswer:
    lea     dx, Crrct
    mov     ah, 9
    int     21h
     
    call    Newline  
    mov     bl, 1    
    
EndQuestion3:
    pop     di
    pop     si
    pop     ax
    pop     dx
    ret
SolveQuestion3 endp      


SolveQuestion4 proc
    push    dx
    push    ax  
    push    si
    push    di 
    
    call    calculate_timer
    mov     countdown, ax
    mov     time_out, 0
    
    ; --- Display Questions and Options ---  
    lea     dx, Q4 
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q4A
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q4B
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q4C
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q4D
    mov     ah, 9
    int     21h 
    call    Newline   
    
    ; --- Start Timer ---
TimerLoop4:
    call    show_timer
    call    delay_1sec
    dec     countdown
    jz      TimeExpired4
    
    ; --- Check for Keystroke ---
    mov     ah, 01h      
    int     16h  
    jz      TimerLoop4     
    
    ; --- Read the key and process ---  
    call    Newline
    mov     ah, 00h
    int     16h  
    
    ; --- Store Character ---
    mov     [Q4UserAnswer], al  
    mov     byte ptr [Q4UserAnswer+1], 0 

    ; --- Echo the input ---
    mov     ah, 02h
    mov     dl, al
    int     21h
     
    call    Newline   
    jmp     ProcessAnswer4  
    
TimeExpired4:
    mov     time_out, 1
    call    Newline
    jmp     Q4WrongAnswer 
    
ProcessAnswer4: 
    ; --- Upper Case Input ---     
    lea     si, Q4SolC
    lea     di, Q4UserAnswer 
    
    call    CompareChar
    cmp     ax, 0
    je      Q4CorrectAnswer 
    
    ; --- Lower Case Input ---
    lea     si, Q4SolS 
    lea     di, Q4UserAnswer  
    
    call    CompareChar
    cmp     ax, 0 
    
    je      Q4CorrectAnswer 
    jmp     Q4WrongAnswer
    
Q4WrongAnswer:
    lea     dx, Wrng
    mov     ah, 9
    int     21h 
    
    call    Newline  
    call    Peep
     
    mov     bl, 0  
    jmp     EndQuestion4 
    
Q4CorrectAnswer:
    lea     dx, Crrct
    mov     ah, 9
    int     21h
     
    call    Newline  
    mov     bl, 1    
    
EndQuestion4:
    pop     di
    pop     si
    pop     ax
    pop     dx
    ret
SolveQuestion4 endp


SolveQuestion5 proc
    push    dx
    push    ax  
    push    si
    push    di 
    
    call    calculate_timer
    mov     countdown, ax
    mov     time_out, 0
    
    ; --- Display Questions and Options ---  
    lea     dx, Q5 
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q5A
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q5B
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q5C
    mov     ah, 9
    int     21h 
    call    Newline

    lea     dx, Q5D
    mov     ah, 9
    int     21h 
    call    Newline   
    
    ; --- Start Timer ---
TimerLoop5:
    call    show_timer
    call    delay_1sec
    dec     countdown
    jz      TimeExpired5
    
    ; --- Check for Keystroke ---
    mov     ah, 01h      
    int     16h  
    jz      TimerLoop5     
    
    ; --- Read the key and process ---  
    call    Newline
    mov     ah, 00h
    int     16h  
    
    ; --- Store Character ---
    mov     [Q5UserAnswer], al  
    mov     byte ptr [Q5UserAnswer+1], 0 

    ; --- Echo the input ---
    mov     ah, 02h
    mov     dl, al
    int     21h
     
    call    Newline   
    jmp     ProcessAnswer5  
    
TimeExpired5:
    mov     time_out, 1
    call    Newline
    jmp     Q5WrongAnswer 
    
ProcessAnswer5: 
    ; --- Upper Case Input ---     
    lea     si, Q5SolC
    lea     di, Q5UserAnswer 
    
    call    CompareChar
    cmp     ax, 0
    je      Q5CorrectAnswer 
    
    ; --- Lower Case Input ---
    lea     si, Q5SolS 
    lea     di, Q5UserAnswer  
    
    call    CompareChar
    cmp     ax, 0 
    
    je      Q5CorrectAnswer 
    jmp     Q5WrongAnswer
    
Q5WrongAnswer:
    lea     dx, Wrng
    mov     ah, 9
    int     21h 
    
    call    Newline  
    call    Peep
     
    mov     bl, 0  
    jmp     EndQuestion5 
    
Q5CorrectAnswer:
    lea     dx, Crrct
    mov     ah, 9
    int     21h
     
    call    Newline  
    mov     bl, 1    
    
EndQuestion5:
    pop     di
    pop     si
    pop     ax
    pop     dx
    ret
SolveQuestion5 endp


; --- Copy From Buffer ---                
CopyInputTo proc
    push    cx
    push    si
    push    di
    
    ; --- Length w/o Return Carrige ---
    mov     cl, byte ptr [si-1] 
     
CopyLoop:   
    
    ; --- counter = 0? ---
    test    cl, cl
    jz      CopyDone          
    mov     al, [si]
    mov     [di], al   
    
    inc     si
    inc     di
    dec     cl
    jnz     CopyLoop 
            
CopyDone:
    ; --- Add null delimiter ---
    mov     byte ptr [di],0 
        
    pop     di
    pop     si
    pop     cx
    ret
CopyInputTo endp 


; --- Print a newline ---
NewLine proc 
    push    ax
    push    dx
    
    ; --- Print Carriage Return ASCII = 13 ---    
    mov     ah, 2
    mov     dl, 13
    int     21h 
    
    ; --- Print Line Feed ASCII = 10 ---
    mov     dl, 10
    int     21h 
       
    pop     dx
    pop     ax
    ret
NewLine endp

 
; --- Peep Sound at Mistake --- 
Peep proc    
    push    ax
    push    dx
    push    cx 
       
    ; --- First Peep ---
    mov     ah, 02h     
    mov     dl, 07h     
    int     21h
            
    ; --- Simple Delay ---  
    mov     cx, 0000h
    mov     dx, 4240h
    mov     ah, 86h    
    int     15h
               
    ; --- Second Peep ---
    mov     ah, 02h    
    mov     dl, 07h
    int     21h 
        
    pop     cx
    pop     dx
    pop     ax    
    ret
Peep endp 


; --- Username\Password Comparison ---
CompareStrings proc
    push    si
    push    di 
    
CmpLoop:
    mov     al, [si]
    mov     bl, [di]
    cmp     al, bl
    jne     NotEqual 
    
    ; --- end of strings = equal ---
    cmp     al, 0
    je      Equal
            
    inc     si
    inc     di
    jmp     CmpLoop 
    
NotEqual:
    ; --- ax = 1 ---
    mov     ax, 1
    pop     di
    pop     si
    ret                
Equal:
    ; --- ax = 0 ---
    xor     ax,ax
    pop     di
    pop     si
    ret
CompareStrings endp 


; --- Input Characters Comparisons ---
CompareChar proc
    mov     al, [si]
    cmp     al, [di]
    je  CharEqual
    mov     ax, 1
    ret 
    
CharEqual:
    mov     ax, 0
    ret
CompareChar endp 


code ends
end start