
#Requires AutoHotkey v2.0

#SingleInstance
#UseHook

; Prevent Alt from activating the menu when we synthesize Alt keystrokes
A_MenuMaskKey := "vk07"  ; Unused virtual key recommended to mask Alt menu activation


;-------------------------------------------------------------------------------
; Convenience
;-------------------------------------------------------------------------------

; Use CapsLock as Escape, and Shift+CapsLock for CapsLock
CapsLock::Esc
+CapsLock::CapsLock


;-------------------------------------------------------------------------------
; Swap Ctrl and Alt
;-------------------------------------------------------------------------------

; Q
!q::!F4 ; alt+q to force quit application
^q::!q

; W
!w::^w
^w::!w

; E
!e::^e
^e::!e

; R
!r::^r
^r::!r

; T
!t::^t
^t::!t

; Y
!y::^y
^y::!y

; U
!u::^u
^u::!u

; I
!i::^i
^i::!i

; O
!o::^o
^o::!o

; P
!p::^p
^p::!p

; A
!a::^a
^a::!a

; S
!s::^s
^s::!s

; D
!d::^d
^d::!d

; F
!f::^f
^f::!f

; G
!g::^g
^g::!g

; Z
!z::^z
^z::!z

; X
!x::^x
^x::!x

; C
!c::^c
^c::!c

; V
!v::^v
^v::!v

; B
!b::^b
^b::!b

; N
!n::^n
^n::!n

; M
!m::^m
^m::!m

