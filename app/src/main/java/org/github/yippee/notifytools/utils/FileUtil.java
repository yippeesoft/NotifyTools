package org.github.yippee.notifytools.utils;

import android.graphics.Bitmap;

import java.io.File;
import java.io.FileOutputStream;

/**
 * Created by shengfang on 2018/1/10.
 */

public class FileUtil {

    public static boolean saveImage(String fileName, Bitmap bitmap){
        boolean brtn=false;
        File fileImage = null;
        if (bitmap == null)
            return brtn;
        fileImage = new File(fileName);

        try {
            if (!fileImage.exists()) {
//                fileImage.createNewFile();
            }else {
                fileImage.delete();
            }
            FileOutputStream out = new FileOutputStream(fileImage);
            if (out != null) {
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
                out.flush();
                out.close();
            }
            brtn=true;

        }catch (Exception e){
            e.printStackTrace();

        }
        return brtn;
    }
}
