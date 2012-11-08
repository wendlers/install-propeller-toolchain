' Blink LED on port 16

CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

PUB LedOnOff                        ' Method declaration 
                       
    dira[16] := 1                   ' Set P16 to output

    repeat                          ' Endless loop prevents
                                    ' program from ending.
     
        outa[16] := 1               ' Set P16 high 
        waitcnt(clkfreq/4 + cnt)    ' Wait a moment
        outa[16] := 0               ' Set P16 low
        waitcnt(clkfreq/4 + cnt)    ' Wait a moment
