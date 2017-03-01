package org.github.yippee.notifytools.media;

import android.graphics.Bitmap;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Created by sf on 2017/3/1.
 */

public class BmpUtils {
    public static void savePic(Bitmap b, String filePath, String fileName) {
        File f = new File(filePath);
        if (!f.exists()) {
            f.mkdir();
        }
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(filePath + File.separator + fileName);
            if (null != fos) {
                b.compress(Bitmap.CompressFormat.PNG, 90, fos);
                fos.flush();
                fos.close();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
