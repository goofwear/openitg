/* LibTomCrypt, modular cryptographic library -- Tom St Denis
 *
 * LibTomCrypt is a library that provides various cryptographic
 * algorithms in a highly modular and flexible manner.
 *
 * The library is free for all purposes without any express
 * guarantee it works.
 *
 * Tom St Denis, tomstdenis@gmail.com, http://libtomcrypt.com
 */
#include "tomcrypt.h"

/**
  @file f9_test.c
  f9 Support, Test F9 mode 
*/

#ifdef LTC_F9_MODE

/** Test f9-MAC mode
  Return CRYPT_OK on succes
*/
int f9_test(void)
{
#ifdef LTC_NO_TEST
   return CRYPT_NOP;
#else
   static const struct {
       int msglen;
       unsigned char K[16], M[128], T[4];
   } tests[] = {
{
   20,
   { 0x2B, 0xD6, 0x45, 0x9F, 0x82, 0xC5, 0xB3, 0x00, 0x95, 0x2C, 0x49, 0x10, 0x48, 0x81, 0xFF, 0x48 },
   { 0x38, 0xA6, 0xF0, 0x56, 0xB8, 0xAE, 0xFD, 0xA9, 0x33, 0x32, 0x34, 0x62, 0x63, 0x39, 0x38, 0x61, 0x37, 0x34, 0x79, 0x40 },
   { 0x46, 0xE0, 0x0D, 0x4B }
},

{
   105,
   { 0x83, 0xFD, 0x23, 0xA2, 0x44, 0xA7, 0x4C, 0xF3, 0x58, 0xDA, 0x30, 0x19, 0xF1, 0x72, 0x26, 0x35 },
   { 0x36, 0xAF, 0x61, 0x44, 0x4F, 0x30, 0x2A, 0xD2, 
     0x35, 0xC6, 0x87, 0x16, 0x63, 0x3C, 0x66, 0xFB, 0x75, 0x0C, 0x26, 0x68, 0x65, 0xD5, 0x3C, 0x11, 0xEA, 0x05, 0xB1, 0xE9, 0xFA, 0x49, 0xC8, 0x39, 0x8D, 0x48, 0xE1, 0xEF, 0xA5, 0x90, 0x9D, 0x39,
     0x47, 0x90, 0x28, 0x37, 0xF5, 0xAE, 0x96, 0xD5, 0xA0, 0x5B, 0xC8, 0xD6, 0x1C, 0xA8, 0xDB, 0xEF, 0x1B, 0x13, 0xA4, 0xB4, 0xAB, 0xFE, 0x4F, 0xB1, 0x00, 0x60, 0x45, 0xB6, 0x74, 0xBB, 0x54, 0x72,
     0x93, 0x04, 0xC3, 0x82, 0xBE, 0x53, 0xA5, 0xAF, 0x05, 0x55, 0x61, 0x76, 0xF6, 0xEA, 0xA2, 0xEF, 0x1D, 0x05, 0xE4, 0xB0, 0x83, 0x18, 0x1E, 0xE6, 0x74, 0xCD, 0xA5, 0xA4, 0x85, 0xF7, 0x4D, 0x7A,
     0x40|0x80 },
   { 0x95, 0xAE, 0x41, 0xBA },
}
};
  unsigned char T[16];
  unsigned long taglen;
  int err, x, idx;

  /* find kasumi */
  if ((idx = find_cipher("kasumi")) == -1) {
     return CRYPT_NOP;
  }

  for (x = 0; x < (int)(sizeof(tests)/sizeof(tests[0])); x++) {
     taglen = 4;
     if ((err = f9_memory(idx, tests[x].K, 16, tests[x].M, tests[x].msglen, T, &taglen)) != CRYPT_OK) {
        return err;
     }
     if (taglen != 4 || XMEMCMP(T, tests[x].T, 4)) {
        return CRYPT_FAIL_TESTVECTOR;
     }
  }

  return CRYPT_OK;
#endif
}

#endif

/* $Source$ */
/* $Revision$ */
/* $Date$ */

