" Vim syntax file
" Language:	Propeller Spin
" Maintainer:	Andrey Demenev <demenev@gmail.com>
" Last Change:	2009 Dec 13

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match spinLocalLabel	":[a-z_][a-z0-9_]*"
syn match spinIdentifier	"[a-z_][a-z0-9_]*"


syn keyword spinType BYTE
syn keyword spinType LONG
syn keyword spinType ROUND
syn keyword spinType TRUNC
syn keyword spinType FLOAT
syn keyword spinType WORD


syn keyword spinCond IF_ALWAYS IF_NEVER IF_E IF_Z IF_NE IF_NZ
syn keyword spinCond IF_NC_AND_NZ IF_NZ_AND_NC IF_A IF_B IF_C
syn keyword spinCond IF_AE IF_NC IF_C_OR_Z IF_Z_OR_C IF_BE
syn keyword spinCond IF_C_EQ_Z IF_Z_EQ_C IF_C_NE_Z IF_Z_NE_C
syn keyword spinCond IF_C_AND_Z IF_Z_AND_C IF_C_AND_NZ
syn keyword spinCond IF_NZ_AND_C IF_NC_AND_Z IF_Z_AND_NC 
syn keyword spinCond IF_C_OR_NZ IF_NZ_OR_C IF_NC_OR_Z
syn keyword spinCond IF_Z_OR_NC IF_NC_OR_NZ IF_NZ_OR_NC 

syn keyword spinCond WC WZ WR NR

syn keyword spinCond IF ELSE ELSEIF ELSEIFNOT IFNOT CASE OTHER
syn keyword spinCond REPEAT FROM TO STEP UNTIL WHILE NEXT
syn keyword spinCond QUIT


syn keyword spinReserved ABS ABSNEG ADD ADDABS ADDS ADDSX ADDX AND
syn keyword spinReserved ANDN BYTEFILL BYTEMOVE CALL CHIPVER
syn keyword spinReserved CLKFREQ _CLKFREQ CLKMODE _CLKMODE CLKSET CMP CMPS
syn keyword spinReserved CMPSUB CMPSX CMPX CNT COGID COGINIT COGNEW
syn keyword spinReserved COGSTOP CON CONSTANT CTRA CTRB DAT DIRA DIRB
syn keyword spinReserved DJNZ ENC FALSE FILE FIT
syn keyword spinReserved _FREE FRQA FRQB HUBOP 
syn keyword spinReserved INA INB
syn keyword spinReserved JMP JMPRET LOCKCLR LOCKNEW LOCKRET LOCKSET LONGFILL
syn keyword spinReserved LONGMOVE LOOKDOWN LOOKDOWNZ LOOKUP LOOKUPZ MAX MAXS MIN MINS
syn keyword spinReserved MOV MOVD MOVI MOVS MUL MULS MUXC MUXNC MUXNZ MUXZ NEG NEGC
syn keyword spinReserved NEGNC NEGNZ NEGX NEGZ NOP NOT OBJ ONES OR ORG 
syn keyword spinReserved OUTA OUTB PAR PHSA PHSB PI PLL16X PLL1X PLL2X PLL4X PLL8X
syn keyword spinReserved POSX PRI PUB RCFAST RCL RCR RCSLOW RDBYTE RDLONG RDWORD
syn keyword spinReserved REBOOT RES RESULT RET REV ROL ROR SAR SHL
syn keyword spinReserved SHR SPR _STACK STRCOMP STRING STRSIZE SUB SUBABS SUBS
syn keyword spinReserved SUBSX SUBX SUMC SUMNC SUMNZ SUMZ TEST TESTN TJNZ TJZ 
syn keyword spinReserved TRUE VAR VCFG VSCL WAITCNT WAITPEQ WAITPNE WAITVID
syn keyword spinReserved WORDFILL WORDMOVE WRBYTE WRLONG WRWORD
syn keyword spinReserved _XINFREQ XINPUT XOR XTAL1 XTAL2 XTAL3 
syn keyword spinReserved RETURN ABORT

" Various #'s as defined by GAS ref manual sec 3.6.2.1
" Technically, the first decNumber def is actually octal,
" since the value of 0-7 octal is the same as 0-7 decimal,
" I prefer to map it as decimal:
syn match decNumber		"#\?[0-9][0-9_]*"
syn match hexNumber		"#\?\$[0-9a-fA-F_]\+"
syn match binNumber		"#\?%[01_]\+\>"
syn match quatNumber		"#\?%%[0-3_]\+\>"


syn match spinComment		"'.*"
syn region spinMLComment start="{" end="}" 
syn region spinMLDocComment start="{{" end="}}" 
syn region spinString start="\"" end="\""


syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_spin_syntax_inits")
  if version < 508
    let did_spin_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink spinLocalLabel	Label
  HiLink spinComment	Comment
  HiLink spinMLComment	Comment
  HiLink spinMLDocComment	Comment
  
  HiLink spinString	String

  HiLink spinCond	PreCondit
  HiLink spinReserved	Special

  HiLink hexNumber	Number
  HiLink decNumber	Number
  HiLink octNumber	Number
  HiLink binNumber	Number
  HiLink quatNumber	Number

  HiLink spinIdentifier Identifier
  HiLink spinType	Type

  delcommand HiLink
endif

let b:current_syntax = "spin"

" vim: ts=8
