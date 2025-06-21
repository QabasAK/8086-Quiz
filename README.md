# Customizable Quiz Game in 8086 Microprocessor using emu8086

This project is an interactive quiz game developed in 8086 assembly. The game focuses on computational complexity and the P vs. NP problem, offering a multiple-choice question (MCQ) format with features like user authentication, random question shuffling, case-insensitive input, a personalized timer, and a session-persistent leaderboard.

 <p align="center">
   <img src="https://github.com/user-attachments/assets/54502b5c-5547-44b6-9e43-b8a32579b632" alt="Demo" width=75%>
 </p>

The features implemented in the quiz system:
+ **User Authentication:** Supports three hard-coded username-password pairs with three login attempts before termination.
+ **Quiz System:** Includes five MCQ questions on computational complexity, shuffled randomly per session using a BIOS system clock seed.
+ **Case-Insensitive Input:** Accepts answers in both uppercase and lowercase.
+ **Personalized Timer:** Each question has a 12-second timer based on the last digit of my university ID, using BIOS-based delays.
+ **Score Tracking & Leaderboard:** Tracks scores per user and displays a leaderboard at the end of the session.
+ **Modular Design:** Utilizes helper procedures like `Newline`, `Peep`, and `Comparison` to ensure clean and reusable code.

### Program Structure 
 #### Data Segment 
 The data segment stores all static and dynamic information required by the program. The following showcases the structure for each username-password pair, MCQ question as well as reading input. 
 ```
UserX db "Name" , 0
PassX db "Pass00" , 0

Qx db ’ Qx : What does it mean ... ?$’
QxA db ’A . ... $’
QxB db ’B . ... $’
QxC db ’C . ... $’
QxD db ’D . ... $’

QxSolC db ’Y’ , 0
QxSolS db ’y’ , 0
QxIn db 2 Ah , 0 , 2 Ah dup ( 0 )
QxUserAnswer db 3 dup ( 0 )
```
#### Flowchart 
The flowchart illustrates the logical sequence of the quiz program, from user authentication to quiz completion and leaderboard display.

 <p align="center">
   <img src="https://github.com/user-attachments/assets/92b68d91-f4d7-454d-aaa3-64fa2714f5ed" alt="Flowchart" width=60%>
 </p>
 
This project demonstrates the power and complexity of 8086 assembly programming through an interactive quiz game. It integrates low-level concepts like BIOS interrupts, memory management, and timing analysis, making it a valuable educational tool for microprocessor studies.
