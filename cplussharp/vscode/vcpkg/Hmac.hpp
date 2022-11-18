#ifndef HMAC_HPP
#define HMAC_HPP
#include <openssl/hmac.h>
#include <openssl/engine.h>
#include <cppcodec/base32_crockford.hpp>
#include <cppcodec/base64_rfc4648.hpp>
#include <iostream>
namespace iot {
class Hmac
{
private:
    void static Mac_Hmac(string key, string data, unsigned char* result, unsigned int& resultlen)
    {
        const unsigned char* bdata
            = (unsigned char*)data.data(); // reinterpret_cast<unsigned char*>(const_cast<char*>(strtest.c_str()));
        HMAC(EVP_sha1(), key.data(), key.length(), bdata, data.length(), result, &resultlen);
    }

    string static Base64Encode(unsigned char* data, unsigned int len)
    {
        using base32 = cppcodec::base32_crockford;
        using base64 = cppcodec::base64_rfc4648;

        string base = base64::encode(data, len);
        return base;
    }
    //github.com/qiniu-c-sdk/qiniu
    void Hmac_inner(
        char* key, const char* items[], size_t items_len, const char* addition, size_t addlen, unsigned char* digest,
        unsigned int* digest_len)
    {
#if OPENSSL_VERSION_NUMBER < 0x10100000
        HMAC_CTX ctx;
        HMAC_CTX_init(&ctx);
        HMAC_Init_ex(&ctx, key, strlen(key), EVP_sha1(), NULL);
        for (size_t i = 0; i < items_len; i++) { HMAC_Update(&ctx, items[i], strlen(items[i])); }
        HMAC_Update(&ctx, "\n", 1);
        if (addlen > 0)
        {
            HMAC_Update(&ctx, addition, addlen);
        }
        HMAC_Final(&ctx, digest, digest_len);
        HMAC_cleanup(&ctx);
#endif

#if OPENSSL_VERSION_NUMBER >= 0x30000000
        char allitems[1024] = "";
        int allitemslen = 0;
        for (size_t i = 0; i < items_len; i++)
        {
            strcat(allitems, items[i]);
            allitemslen += strlen(items[i]);
        }
        strcat(allitems, "\n");
        allitemslen++;
        if (addlen > 0)
        {
            strcat(allitems, addition);
            allitemslen += addlen;
        }
        HMAC(EVP_sha1(), key, strlen(key), reinterpret_cast<unsigned char*>(allitems), allitemslen, digest, digest_len);
#elif OPENSSL_VERSION_NUMBER > 0x10100000
        HMAC_CTX* ctx = HMAC_CTX_new();
        HMAC_Init_ex(ctx, key, strlen(key), EVP_sha1(), NULL);
        for (size_t i = 0; i < items_len; i++) { HMAC_Update(ctx, items[i], strlen(items[i])); }
        HMAC_Update(ctx, "\n", 1);
        if (addlen > 0)
        {
            HMAC_Update(ctx, addition, addlen);
        }
        HMAC_Final(ctx, digest, digest_len);
        HMAC_CTX_free(ctx);
#endif
    }

public:
    string static Mac_Base64(string key, string data)
    {
        unsigned char result[100] = {0};
        unsigned int resultlen = 100;
        Mac_Hmac(key, data, result, resultlen);
        string m = Base64Encode(result, resultlen);
        return m;
    }
};
} // namespace iot
#endif