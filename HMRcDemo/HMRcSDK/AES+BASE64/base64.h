//******************************************************
// BASE64 encode&decode

#ifndef _BASE64_H_
#define _BASE64_H_

extern char * base64_encode(const unsigned char * bindata, char * base64, int binlength);
extern int base64_decode(const unsigned  char * base64, unsigned char * bindata);

#endif /* _BASE64_H_ */
