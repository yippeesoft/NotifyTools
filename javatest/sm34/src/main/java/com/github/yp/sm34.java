package com.github.yp;

import java.security.Key;
import java.security.Security;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import org.bouncycastle.crypto.digests.SM3Digest;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.util.encoders.Hex;

public class sm34 {
    public static final String ALGORITHM_NAME = "SM4";
    public static final String ALGORITHM_NAME_ECB_PADDING = "SM4/ECB/PKCS5Padding";
    public static final String ALGORITHM_NAME_CBC_PADDING = "SM4/CBC/PKCS5Padding";

    public static void sm3() {
        byte[] md = new byte[32];
        SM3Digest sm3 = new SM3Digest();
        byte[] msg1 = "abc".getBytes();
        sm3.update(msg1, 0, msg1.length);
        sm3.doFinal(md, 0);
        String s = new String(Hex.toHexString(md));
        System.out.println(s.toUpperCase());
    }

    public static void sm4() {
        Cipher cipher;
        try {
            // Security.addProvider(new BouncyCastleProvider());
            // if (Security.getProvider(BouncyCastleProvider.PROVIDER_NAME) == null) {
            //     System.out.println("security provider BC not found");
            //     Security.addProvider(new BouncyCastleProvider());
            // }
            cipher = Cipher.getInstance(ALGORITHM_NAME_ECB_PADDING,new BouncyCastleProvider());
            Key sm4Key = new SecretKeySpec(Hex.decode("11111111111111111111111111111111"), ALGORITHM_NAME);
            cipher.init(Cipher.ENCRYPT_MODE, sm4Key);
            byte[] sm4 = cipher.doFinal("abc".getBytes());
            System.out.println(Hex.toHexString(sm4));

            cipher.init(Cipher.DECRYPT_MODE, sm4Key);
            sm4 = cipher.doFinal(sm4);
            System.out.println(new String(sm4));
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {
        sm3();
        for (int i = 0; i < 10000000; i++) {
            sm4();
            sm4();
        }

    }
}
