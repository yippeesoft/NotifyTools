package org.opencv.samples.facedetect;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;


import org.bytedeco.javacpp.opencv_core;
import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.CameraBridgeViewBase;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;
import org.opencv.android.Utils;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
import org.opencv.core.Size;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import static org.bytedeco.javacpp.helper.opencv_imgproc.cvCalcHist;
import static org.bytedeco.javacpp.opencv_core.CV_HIST_ARRAY;
import static org.bytedeco.javacpp.opencv_core.IPL_DEPTH_8U;
import static org.bytedeco.javacpp.opencv_imgcodecs.CV_LOAD_IMAGE_GRAYSCALE;
import static org.bytedeco.javacpp.opencv_imgcodecs.cvLoadImage;
import static org.bytedeco.javacpp.opencv_imgproc.CV_COMP_BHATTACHARYYA;
import static org.bytedeco.javacpp.opencv_imgproc.CV_COMP_CHISQR;
import static org.bytedeco.javacpp.opencv_imgproc.CV_COMP_CORREL;
import static org.bytedeco.javacpp.opencv_imgproc.CV_COMP_INTERSECT;
import static org.bytedeco.javacpp.opencv_imgproc.cvCompareHist;
import static org.bytedeco.javacpp.opencv_imgproc.cvNormalizeHist;


/**
 * Created by sf on 2018/1/23.
 */
//https://www.cnblogs.com/haoxr/p/7686847.html
public class JpgFace extends Activity {

    private static final String    TAG                 = "JpgFace::Activity";
    int nums=2;
    Bitmap bmpSrc[]=new Bitmap[2];

    ImageView[] imgSrc=new ImageView[2];

    Bitmap bmpDst[]=new Bitmap[2];

    ImageView[] imgDst=new ImageView[2];

    RelativeLayout rlmain;

    String[] src={ "/sdcard/Face/ll.jpg","/sdcard/Face/ll3.jpg" };
//    private ObjectDetection mFaceDetector;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        Log.i(TAG, "called onCreate");
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        rlmain=new RelativeLayout(this);
        setContentView(rlmain);
        rlmain.setBackgroundColor(Color.RED);

        for(int i=0;i<nums;i++){
            imgSrc[i]=new ImageView(rlmain.getContext());
            RelativeLayout.LayoutParams p=new RelativeLayout.LayoutParams(500,500);
            p.leftMargin=600*i;


            bmpSrc[i] = BitmapFactory.decodeFile(src[i]);
            imgSrc[i].setImageBitmap(bmpSrc[i]);
//            imgSrc[i].setImageURI(Uri.p);
            imgSrc[i].setBackgroundColor(Color.BLUE);
//            imgSrc[i].setScaleType(ImageView.ScaleType.CENTER);
            rlmain.addView(imgSrc[i],p);
        }

        for(int i=0;i<nums;i++){
            imgDst[i]=new ImageView(rlmain.getContext());
            RelativeLayout.LayoutParams p=new RelativeLayout.LayoutParams(500,500);
            p.leftMargin=600*i;
            p.topMargin=600 ;
            rlmain.addView(imgDst[i],p);
            imgDst[i].setBackgroundColor(Color.DKGRAY);
        }


        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                detectFace();
                double d=CmpPic("/sdcard/mat0.jpg","/sdcard/mat1.jpg");  //CmpPic(bmpDst[0],bmpDst[1]);
                Log.e(TAG,"CmpPic "+d);
            }
        },3000) ;
    }

    private int                    mAbsoluteFaceSize   = 0;
    private float                  mRelativeFaceSize   = 0.2f;

    /**
     * 特征对比
     *
     * @param file1 人脸特征
     * @param file2 人脸特征
     * @return 相似度
     */
    public double CmpPic(String file1, String file2) {
        int l_bins = 20;
        int hist_size[] = {l_bins};

        float v_ranges[] = {0, 100};
        float ranges[][] = {v_ranges};

        opencv_core.IplImage Image1 = cvLoadImage(file1, CV_LOAD_IMAGE_GRAYSCALE);
        opencv_core.IplImage Image2 = cvLoadImage(file2, CV_LOAD_IMAGE_GRAYSCALE);

        opencv_core.IplImage imageArr1[] = {Image1};
        opencv_core.IplImage imageArr2[] = {Image2};

        opencv_core.CvHistogram Histogram1 = opencv_core.CvHistogram.create(1, hist_size, CV_HIST_ARRAY, ranges, 1);
        opencv_core.CvHistogram Histogram2 = opencv_core.CvHistogram.create(1, hist_size, CV_HIST_ARRAY, ranges, 1);

        cvCalcHist(imageArr1, Histogram1, 0, null);

        cvCalcHist(imageArr2, Histogram2, 0, null);

        cvNormalizeHist(Histogram1, 1);
        cvNormalizeHist(Histogram2, 1);

        Log.d(TAG,"CV_COMP_CORREL : "+cvCompareHist(Histogram1,Histogram2,CV_COMP_CORREL));
        Log.d(TAG,"CV_COMP_CHISQR :  "+cvCompareHist(Histogram1,Histogram2,CV_COMP_CHISQR));
        Log.d(TAG,"CV_COMP_INTERSECT :  "+cvCompareHist(Histogram1,Histogram2,CV_COMP_INTERSECT));
        Log.d(TAG,"CV_COMP_BHATTACHARYYA :  "+cvCompareHist(Histogram1,Histogram2,CV_COMP_BHATTACHARYYA));

        return cvCompareHist(Histogram1, Histogram2, CV_COMP_CORREL);
    }

    public double CmpPic(Bitmap file1, Bitmap file2) {
        int l_bins = 20;
        int hist_size[] = {l_bins};

        float v_ranges[] = {0, 100};
        float ranges[][] = {v_ranges};

        Log.e(TAG,file1.getWidth()+" "+file1.getHeight()+"  "+file1.getDensity());
        Log.e(TAG,file2.getWidth()+" "+file2.getHeight()+"  "+file2.getDensity());
        opencv_core.IplImage Image1 = bitmapToIplImage(file1); //cvLoadImage(file1, CV_LOAD_IMAGE_GRAYSCALE);
        opencv_core.IplImage Image2 = bitmapToIplImage(file2); //cvLoadImage(file2, CV_LOAD_IMAGE_GRAYSCALE);

        opencv_core.IplImage imageArr1[] = {Image1};
        opencv_core.IplImage imageArr2[] = {Image2};

        opencv_core.CvHistogram Histogram1 = opencv_core.CvHistogram.create(1, hist_size, CV_HIST_ARRAY, ranges, 1);
        opencv_core.CvHistogram Histogram2 = opencv_core.CvHistogram.create(1, hist_size, CV_HIST_ARRAY, ranges, 1);

        cvCalcHist(imageArr1, Histogram1, 0, null);
        cvCalcHist(imageArr2, Histogram2, 0, null);

        cvNormalizeHist(Histogram1, 100.0);
        cvNormalizeHist(Histogram2, 100.0);

        return cvCompareHist(Histogram1, Histogram2, CV_COMP_CORREL);
    }
    /**
     * IplImage转化为Bitmap
     * @param iplImage
     * @return
     */
    public Bitmap IplImageToBitmap(opencv_core.IplImage iplImage) {
        Bitmap bitmap = null;
        bitmap = Bitmap.createBitmap(iplImage.width(), iplImage.height(),
                Bitmap.Config.ARGB_8888);
        bitmap.copyPixelsFromBuffer(iplImage.getByteBuffer());
        return bitmap;
    }

    /**
     * Bitmap转化为IplImage
     * @param bitmap
     * @return
     */
    public opencv_core.IplImage bitmapToIplImage(Bitmap bitmap) {
        opencv_core.IplImage iplImage;
        iplImage = opencv_core.IplImage.create(bitmap.getWidth(), bitmap.getHeight(),
                IPL_DEPTH_8U, 4);
        bitmap.copyPixelsToBuffer(iplImage.getByteBuffer());
        return iplImage;
    }

    private void detectFace() {
        try {

            // bitmapToMat
            Log.e(TAG,"detectFace begin");

            for(int i=0;i<2;i++) {
                Mat toMat = new Mat();

                bmpDst[i] = Bitmap.createBitmap(bmpSrc[i].getWidth(), bmpSrc[i].getHeight(), Bitmap.Config.ARGB_8888);

                Utils.bitmapToMat(bmpSrc[i], toMat);
                Mat copyMat = new Mat();
                toMat.copyTo(copyMat); // 复制

                // togray
                Mat gray = new Mat();
                Imgproc.cvtColor(toMat, gray, Imgproc.COLOR_RGBA2GRAY);

                if (mAbsoluteFaceSize == 0) {
                    int height = gray.rows();
                    if (Math.round(height * mRelativeFaceSize) > 0) {
                        mAbsoluteFaceSize = Math.round(height * mRelativeFaceSize / 3);
                    }
                    mNativeDetector.setMinFaceSize(mAbsoluteFaceSize);
                }
                Log.e(TAG, mRelativeFaceSize + " mRelativeFaceSize " + mAbsoluteFaceSize);

                MatOfRect faces = new MatOfRect();

                mJavaDetector.detectMultiScale(
                        gray, // 要检查的灰度图像
                        faces, // 检测到的人脸
                        1.1, // 表示在前后两次相继的扫描中，搜索窗口的比例系数。默认为1.1即每次搜索窗口依次扩大10%;
                        6, // 默认是3 控制误检测，表示默认几次重叠检测到人脸，才认为人脸存在
                        Objdetect.CASCADE_SCALE_IMAGE,
                        new Size(mAbsoluteFaceSize, mAbsoluteFaceSize), // 目标最小可能的大小
                        gray.size()); // 目标最大可能的大小

//            mJavaDetector.detectMultiScale(gray, faces, 1.1, 2, 2, // TODO: objdetect.CV_HAAR_SCALE_IMAGE
//                    new Size(mAbsoluteFaceSize, mAbsoluteFaceSize), new Size());

                Rect[] facesArray = faces.toArray();
                Log.e("objectLength", facesArray.length + "");


                int maxRectArea = 0 * 0;
                Rect maxRect = null;

                int facenum = 0;
                // Draw a bounding box around each face.
                for (Rect rect : facesArray) {
                    Imgproc.rectangle(
                            toMat,
                            new Point(rect.x, rect.y),
                            new Point(rect.x + rect.width, rect.y + rect.height),
                            new Scalar(255, 0, 0), 3);
                    ++facenum;
                    // 找出最大的面积
                    int tmp = rect.width * rect.height;
                    if (tmp >= maxRectArea) {
                        maxRectArea = tmp;
                        maxRect = rect;
                    }
                }

                Bitmap rectBitmap = null;
                if (facenum != 0) {
                    // 剪切最大的头像
                    Log.e("剪切的长宽", String.format("高:%s,宽:%s", maxRect.width, maxRect.height));
                    Rect rect = new Rect(maxRect.x, maxRect.y, maxRect.width, maxRect.height);

                    Mat rectMat = new Mat(gray, rect);  // 从原始图像拿
                    Mat mat = new Mat();
                    Size size = new Size(100, 100);
                    Imgproc.resize(rectMat, mat, size);

                    rectBitmap = Bitmap.createBitmap(mat.cols(), mat.rows(), Bitmap.Config.ARGB_8888);
                    Utils.matToBitmap(mat, rectBitmap);

                    bmpDst[i]=rectBitmap.copy(rectBitmap.getConfig(),true);
                    imgDst[i].setScaleType(ImageView.ScaleType.CENTER);
                    imgDst[i].setImageBitmap(rectBitmap);
                    Imgcodecs.imwrite("/sdcard/mat"+i+".jpg",mat);
                }

                Log.e(TAG, String.format("检测到%1$d个人脸", facenum));
//                Utils.matToBitmap(toMat, bmpDst[i]);
//                imgDst.setImageBitmap(bmpDst);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.e(TAG,"detectFace end");
    }

    @Override
    public void onResume()
    {
        super.onResume();
        if (!OpenCVLoader.initDebug()) {
            Log.d(TAG, "Internal OpenCV library not found. Using OpenCV Manager for initialization");
            OpenCVLoader.initAsync(OpenCVLoader.OPENCV_VERSION_3_0_0, this, mLoaderCallback);
        } else {
            Log.d(TAG, "OpenCV library found inside package. Using it!");
            mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
        }
    }

    private File                   mCascadeFile;
    private CascadeClassifier      mJavaDetector;
    private DetectionBasedTracker  mNativeDetector;

    private BaseLoaderCallback mLoaderCallback = new BaseLoaderCallback(this) {
        @Override
        public void onManagerConnected(int status) {
            switch (status) {
                case LoaderCallbackInterface.SUCCESS:
                {
                    Log.i(TAG, "OpenCV loaded successfully");

                    // Load native library after(!) OpenCV initialization
                    System.loadLibrary("detection_based_tracker");

                    try {
                        // load cascade file from application resources
                        InputStream is = getResources().openRawResource(R.raw.lbpcascade_frontalface);
                        File cascadeDir = getDir("cascade", Context.MODE_PRIVATE);
                        mCascadeFile = new File(cascadeDir, "lbpcascade_frontalface.xml");
                        FileOutputStream os = new FileOutputStream(mCascadeFile);

                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = is.read(buffer)) != -1) {
                            os.write(buffer, 0, bytesRead);
                        }
                        is.close();
                        os.close();

                        mJavaDetector = new CascadeClassifier(mCascadeFile.getAbsolutePath());
                        if (mJavaDetector.empty()) {
                            Log.e(TAG, "Failed to load cascade classifier");
                            mJavaDetector = null;
                        } else
                            Log.i(TAG, "Loaded cascade classifier from " + mCascadeFile.getAbsolutePath());

                        mNativeDetector = new DetectionBasedTracker(mCascadeFile.getAbsolutePath(), 0);

                        cascadeDir.delete();

                    } catch (IOException e) {
                        e.printStackTrace();
                        Log.e(TAG, "Failed to load cascade. Exception thrown: " + e);
                    }


                } break;
                default:
                {
                    super.onManagerConnected(status);
                } break;
            }
        }
    };

}
