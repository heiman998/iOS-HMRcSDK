//*********************************************************
//	AES128 encrypt&decrypt

// out buf len = dwDataLen + 16 return encrypt data len
unsigned int EncryptBuf(unsigned char *lpInBuf, unsigned int dwDataLen, unsigned char *lpOutBuf, unsigned char *lpKey16Byte); 

// return decrypt data len
unsigned int DecryptBuf(unsigned char *lpInBuf, unsigned int dwDataLen, unsigned char *lpOutBuf, unsigned char *lpKey16Byte);

void HMMakeKey(unsigned char *lpRandom256, unsigned char *lpKey16);
