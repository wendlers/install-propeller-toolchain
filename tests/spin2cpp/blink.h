//
// automatically generated by spin2cpp v1.91 on Mon Sep  1 23:00:21 2014
// spin2cpp --elf -o blink.elf -O -mfcache blink.spin 
//

#ifndef blink_Class_Defined__
#define blink_Class_Defined__

#include <stdint.h>

class blink {
public:
  static const int _clkmode = (8 + 1024);
  static const int _xinfreq = 5000000;
  int32_t	LedOnOff(void);
private:
};

#endif