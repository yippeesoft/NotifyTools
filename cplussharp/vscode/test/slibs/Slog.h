#pragma once
#ifndef SF_SLOG_H
#define SF_SLOG_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#  ifdef MODULE_API_EXPORTS
#    define MODULE_API __declspec(dllexport)
#  else
#    define MODULE_API __declspec(dllimport)
#  endif
#else
#  define MODULE_API
#endif
#include <stdio.h>
	MODULE_API void testLibs();

#ifdef __cplusplus
}
#endif
#endif
