package org.github.yippee.china_poem.poem2db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.SystemClock;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.dictionary.py.Pinyin;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.HanyuPinyinVCharType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import org.github.yippee.china_poem.poem2db.bean.Tangshi;
import org.github.yippee.china_poem.poem2db.dao.gen.TangshiDao;

/**
 * Created by sf on 2017/7/25.
 */

public class Ts2Sqlite {
  static String TAG="Ts2Sqlite";
  public static void getAuthors(Context cxt){
    DBManager dbManager = DBManager.getInstance(cxt);
    TangshiDao tsDao=dbManager.getTangshiDao();
    final String SQL_DISTINCT_ENAME = "SELECT DISTINCT "+TangshiDao.Properties.Author.columnName+" FROM "+TangshiDao.TABLENAME;

    long start=System.currentTimeMillis();
    Log.d(TAG, HanLP.convertToSimplifiedChinese("裴諴"));
    Log.d(TAG, HanLP.convertToSimplifiedChinese("拾得"));

    List<Pinyin> pinyinList ;
    pinyinList= HanLP.convertToPinyinList("曾扈") ;
    String pyname="";
    for (Pinyin pinyin : pinyinList)
    {
      pyname+= pinyin.getPinyinWithToneMark()+" ";
      Log.d(TAG, pinyin.getHead().toString().toUpperCase());
    }
    Log.d(TAG, pyname);

    HanyuPinyinOutputFormat format= new HanyuPinyinOutputFormat();

    format.setToneType(HanyuPinyinToneType.WITH_TONE_MARK);

    format.setVCharType(HanyuPinyinVCharType.WITH_U_UNICODE);
    String[] pinyinArray = null;

    try

    {

      pinyinArray = PinyinHelper.toHanyuPinyinStringArray('曾', format);

    }

    catch(BadHanyuPinyinOutputFormatCombination e)

    {

      e.printStackTrace();

    }

    for(int i = 0; i < pinyinArray.length; ++i)

    {

      Log.d(TAG,i+pinyinArray[i]);

    }

    Cursor c = dbManager.getDaoSession().getDatabase().rawQuery(SQL_DISTINCT_ENAME, null);

    //while(c.moveToNext()){
    //  try {
    //    String ftname=new String(c.getBlob(0),"UTF-16LE");
    //    String jtname= HanLP.convertToSimplifiedChinese(ftname);
    //     pinyinList = HanLP.convertToPinyinList(ftname) ;
    //      pyname="";
    //    for (Pinyin pinyin : pinyinList)
    //    {
    //      pyname+= pinyin.getPinyinWithToneMark()+" ";
    //    }
    //
    //    Log.d(TAG,ftname+" "+jtname+" "+pyname);
    //  } catch (UnsupportedEncodingException e) {
    //    e.printStackTrace();
    //  }
    //}
    c.moveToFirst();
    Log.d(TAG,c.getCount() +" end "+ (System.currentTimeMillis()-start));
  }
  public static void mainGreenDao(Context cxt) {
    Gson gson = new Gson();

    String path = "/sdcard/json";

    String[] jsonfiles = new File(path).list();
    int cnt = 0;
    boolean bstmt=false;
    String database = "/sdcard/tangshi.sqlite";
    String sql;
    if(bstmt==false)
      sql = "insert into tangshi(author,title,paragraphs,strains) values (?,?,?,?)";
    else
      sql = "insert into tangshi(author,title,paragraphs,strains) values ('%s','%s','%s','%s')";
    //Connection conn = null;
    //Statement stmt = null;
    //ResultSet rs = null;
    //PreparedStatement ps = null;
    long start = System.currentTimeMillis();
    int count=0;
    DBManager dbManager = DBManager.getInstance(cxt);//计时：46225 条数：311828

    List<Tangshi> lstTs=new ArrayList<>();
    try {

      for (int i = 0; i < jsonfiles.length; i++) {
        //System.out.println(jsonfiles[i]);
        String fn = path + File.separator + jsonfiles[i];
        InputStream is = null;

        is = new FileInputStream(new File(fn));
        JsonReader reader = new JsonReader(new InputStreamReader(is, "UTF-8"));
        reader.beginArray();
        ArrayList<String> lststrains = new ArrayList<>();

        while (reader.hasNext()) {

          TsBean tsBean = gson.fromJson(reader, TsBean.class);
          if(tsBean.getStrains()==null)
            continue;
          //System.out.println(gson.toJson(tsBean));
          String strains = "";
          for (int j = 0; j < tsBean.getStrains().size(); j++) {
            strains += tsBean.getStrains().get(j);
          }

          String paragraphs = "";
          for (int j = 0; j < tsBean.getParagraphs().size(); j++) {
            paragraphs += tsBean.getParagraphs().get(j);
          }
          Tangshi ts=new Tangshi();
          ts.setAuthor(tsBean.getAuthor());
          ts.setTitle(tsBean.getTitle());
          ts.setParagraphs(paragraphs);
          ts.setStrains(strains);
          lstTs.add(ts);
          count++;

        }
        reader.endArray();
        reader.close();
        is.close();
      }
       dbManager.getTangshiDao().insertInTx(lstTs);

    } catch (Exception e) {
      e.printStackTrace();
    }

    long t2 = System.currentTimeMillis();
    System.out.println("计时："+(t2-start)+" 条数："+count);
  }

  public static void main(String[] args) {
    Gson gson = new Gson();

    String path = "/sdcard/json";

    String[] jsonfiles = new File(path).list();
    int cnt = 0;
    boolean bstmt=false;
    String database = "/sdcard/tangshi.sqlite";
    String sql;
    if(bstmt==false)
      sql = "insert into tangshi(author,title,paragraphs,strains) values (?,?,?,?)";
    else
      sql = "insert into tangshi(author,title,paragraphs,strains) values ('%s','%s','%s','%s')";
    //Connection conn = null;
    //Statement stmt = null;
    //ResultSet rs = null;
    //PreparedStatement ps = null;
    long start = System.currentTimeMillis();
    int count=0;

    SQLiteDatabase db= SQLiteDatabase.openOrCreateDatabase(database,null);
    db.beginTransaction(); //计时：46507 条数：311828
    try {
      //conn = DriverManager.getConnection("jdbc:sqlite:" + database);
      //conn.setAutoCommit(false);  //设为手动提交

      //if(bstmt)
      // stmt = conn.createStatement(); //计时：17360 条数：311828
      //else
      //  ps = conn.prepareStatement(sql); //计时：15640 条数：311828


      for (int i = 0; i < jsonfiles.length; i++) {
        //System.out.println(jsonfiles[i]);
        String fn = path + File.separator + jsonfiles[i];
        InputStream is = null;

        is = new FileInputStream(new File(fn));
        JsonReader reader = new JsonReader(new InputStreamReader(is, "UTF-8"));
        reader.beginArray();
        ArrayList<String> lststrains = new ArrayList<>();

        while (reader.hasNext()) {

          TsBean tsBean = gson.fromJson(reader, TsBean.class);
          if(tsBean.getStrains()==null)
            continue;
          //System.out.println(gson.toJson(tsBean));
          String strains = "";
          for (int j = 0; j < tsBean.getStrains().size(); j++) {
            strains += tsBean.getStrains().get(j);
          }

          String paragraphs = "";
          for (int j = 0; j < tsBean.getParagraphs().size(); j++) {
            paragraphs += tsBean.getParagraphs().get(j);
          }

          db.execSQL(sql,new Object[]{tsBean.getAuthor().getBytes("UTF-16LE"), tsBean.getTitle().getBytes("UTF-16LE")
              , paragraphs.getBytes("UTF-16LE"), strains.getBytes("UTF-16LE")});

          //if(bstmt==false) {
          //  ps.setString(1, tsBean.getAuthor());
          //  ps.setString(2, tsBean.getTitle());
          //  ps.setString(3, paragraphs);
          //  ps.setString(4, strains);
          //
          //  ps.addBatch();
          //}else {
          //  String sqll =
          //      String.format(sql, tsBean.getAuthor(), tsBean.getTitle(), paragraphs, strains);
          //  stmt.addBatch(sqll);
          //}
          count++;
          //System.out.println(sqll);
          //if(lststrains.contains(strains)==false) {
          //  System.out.println("strains :"+cnt+"  " + strains);
          //  lststrains.add(strains);
          //}
          //cnt++;
        }




        reader.endArray();
        reader.close();
        is.close();
      }
      //if(bstmt==false) {
      //  int[] ret = ps.executeBatch();
      //  conn.commit();  //提交事务
      //  ps.clearBatch();
      //}else {
      //  stmt.executeBatch();
      //  conn.commit();  //提交事务
      //  stmt.clearBatch();
      //}
      //显示的设置数据事务是否成功
      db.setTransactionSuccessful();
      db.endTransaction();

      Cursor cursor = db.query ("tangshi",null,null,null,null,null,null);
      System.out.println("Cursor count："+cursor.getCount());
      cursor.close();
      db.close();
    } catch (Exception e) {
      e.printStackTrace();
    }

    long t2 = System.currentTimeMillis();
    System.out.println("计时："+(t2-start)+" 条数："+count);
  }
}
