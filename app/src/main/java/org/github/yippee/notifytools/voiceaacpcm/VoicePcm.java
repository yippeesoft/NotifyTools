package org.github.yippee.notifytools.voiceaacpcm;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.AudioTrack;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Created by shengfang on 2018/1/11.
 */

public class VoicePcm {

    public void testVoice(){
//        btn_rec=(Button)findViewById(R.id.btn_rec);
//        btn_play=(Button)findViewById(R.id.btn_play);
//
//        btn_rec1=(Button)findViewById(R.id.btn_rec1);
//        btn_play1=(Button)findViewById(R.id.btn_play1);
//
//
//        btn_rec.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                new Thread(new Runnable() {
//                    @Override
//                    public void run() {
//                        recorder_Media();
//                    }
//                }).start();
//
//            }
//        });
//
//        btn_play.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                new Thread(new Runnable() {
//                    @Override
//                    public void run() {
//                        play_Media();
//                    }
//                }).start();
//
//            }
//
//        });
//
//        btn_rec1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                new Thread(new Runnable() {
//                    @Override
//                    public void run() {
//                        StartRecord();
//                    }
//                }).start();
//
//            }
//        });
//
//        btn_play1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                new Thread(new Runnable() {
//                    @Override
//                    public void run() {
//
//                        PlayRecord();
//                    }
//                }).start();
//
//            }
//
//        });
    }

    private MediaRecorder mediaRecorder = new MediaRecorder();

    MediaPlayer player=new MediaPlayer();

    private String snd= Environment.getExternalStorageDirectory().getAbsolutePath()+"/test.3gp";
    File audioFile = new File(snd);

    String TAG="REC";
    //16K采集率
    int frequency = 16000;
    //格式
    int channelConfiguration = AudioFormat.CHANNEL_CONFIGURATION_MONO;
    //16Bit
    int audioEncoding = AudioFormat.ENCODING_AC3;

    boolean isRecording=true;
    //开始录音
    public void StartRecord() {
        Log.i(TAG,"开始录音");
        isRecording=true;

//生成PCM文件
        File file = audioFile;//new File(Environment.getExternalStorageDirectory().getAbsolutePath() + "/reverseme.pcm");
        Log.i(TAG,"生成文件");
//如果存在，就先删除再创建
        if (file.exists())
            file.delete();
        Log.i(TAG,"删除文件");
        try {
            file.createNewFile();
            Log.i(TAG,"创建文件");
        } catch (IOException e) {
            Log.i(TAG,"未能创建");
            throw new IllegalStateException("未能创建" + file.toString());
        }
        try {
//输出流
            OutputStream os = new FileOutputStream(file);
            BufferedOutputStream bos = new BufferedOutputStream(os);
            DataOutputStream dos = new DataOutputStream(bos);
            int bufferSize = AudioRecord.getMinBufferSize(frequency, channelConfiguration, audioEncoding);
            AudioRecord audioRecord = new AudioRecord(MediaRecorder.AudioSource.MIC, frequency, channelConfiguration, audioEncoding, bufferSize);
            byte[] buffer = new byte[bufferSize];
            audioRecord.startRecording();
            Log.i(TAG, "开始录音");
            isRecording = true;
            while (isRecording) {
                int bufferReadResult = audioRecord.read(buffer, 0, bufferSize);
                dos.write(buffer,0,bufferReadResult);
            }
            audioRecord.stop();
            dos.close();
        } catch (Throwable t) {
            Log.e(TAG, "录音失败");
        }
    }
    private int bufferSize;
    //播放文件
    public void PlayRecord() {
        File file = audioFile;
        isRecording=false;
        if(file == null){
            return;
        }
        Log.i(TAG,"开始播放");
//读取文件
//        int musicLength = (int) (file.length() / 2);
//        short[] music = new short[musicLength];
        bufferSize = AudioTrack.getMinBufferSize( frequency, channelConfiguration,audioEncoding);
        try {
            Thread.sleep(1000);
            InputStream is = new FileInputStream(file);
            BufferedInputStream bis = new BufferedInputStream(is);
            DataInputStream dis = new DataInputStream(bis);
            byte[] tempBuffer = new byte[bufferSize];
            int i = 0;
            AudioTrack audioTrack = new AudioTrack(AudioManager.STREAM_MUSIC,
                    frequency, channelConfiguration,
                    audioEncoding,
                    bufferSize * 2,
                    AudioTrack.MODE_STREAM);
            android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO);
            int readCount = 0;
            while (dis.available() > 0) {
                readCount= dis.read(tempBuffer);
                if (readCount == AudioTrack.ERROR_INVALID_OPERATION || readCount == AudioTrack.ERROR_BAD_VALUE) {
                    continue;
                }
                if (readCount != 0 && readCount != -1) {
                    audioTrack.play();
                    audioTrack.write(tempBuffer, 0, readCount);
                }
            }
            audioTrack.stop();
            audioTrack.release();
            dis.close();

//            audioTrack.play();
//            audioTrack.write(music, 0, musicLength);

        } catch (Exception t) {
            Log.e(TAG, "播放失败"+t.toString());
        }
    }

    public static final int MAX_LENGTH = 1000 * 60 * 10;// 最大录音时长1000*60*10;
    public void recorder_Media(){
        boolean b=true;
        if(b==false) {
	/* ②setAudioSource/setVedioSource */
            mediaRecorder.setAudioSource(MediaRecorder.AudioSource.DEFAULT);// 设置麦克风
			/* ②设置音频文件的编码：AAC/AMR_NB/AMR_MB/Default 声音的（波形）的採样 */
            mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.DEFAULT);
            			/*
			 * ②设置输出文件的格式：THREE_GPP/MPEG-4/RAW_AMR/Default THREE_GPP(3gp格式
			 * 。H263视频/ARM音频编码)、MPEG-4、RAW_AMR(仅仅支持音频且音频编码要求为AMR_NB)
			 */
            mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);

        }else {
            //配置mMediaRecorder相应参数
            //从麦克风采集声音数据
            mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
            //设置保存文件格式为MP4
            mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
            //设置采样频率,44100是所有安卓设备都支持的频率,频率越高，音质越好，当然文件越大
            mediaRecorder.setAudioSamplingRate(44100); //44100
            mediaRecorder.setAudioChannels(1);
            //设置声音数据编码格式,音频通用格式是AAC
            mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
            //设置编码频率
            mediaRecorder.setAudioEncodingBitRate(16); //96000

        }

        try {

            mediaRecorder.setOutputFile(audioFile.getAbsolutePath());
            mediaRecorder.setMaxDuration(MAX_LENGTH);
            mediaRecorder.prepare();
            mediaRecorder.start();

        } catch ( Exception e) {

            e.printStackTrace();
        }
    }

    public void play_Media(){

        mediaRecorder.stop();
        mediaRecorder.reset();
        mediaRecorder.release();
        mediaRecorder = null;

        try {
            Thread.sleep(1000);
            player.setDataSource(audioFile.getAbsolutePath());//指定要装载的音频文件
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }


        try {
            player.prepare();//预加载音频
            player.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    Log.d("AAA","END");
                    player.stop();
                    player.release();
                }
            });
            player.start();
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch ( Exception e) {
            e.printStackTrace();
        }
    }
}
