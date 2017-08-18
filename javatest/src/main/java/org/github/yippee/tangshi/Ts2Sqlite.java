package org.github.yippee.tangshi;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.dictionary.py.Pinyin;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.beanutils.PropertyUtils;
import org.jetbrains.kotlin.jline.internal.Log;

/**
 * Created by sf on 2017/7/25.
 */

public class Ts2Sqlite {

  public static void main(String[] args) {
    sc2sqlite();
  }

  static void beanutils(){
    long start=System.currentTimeMillis();

    String s;
    String clsname="org.github.yippee.tangshi.TsBean";
    try {

      Class<?> managerClass = Class.forName(clsname);
      Object ts = managerClass.newInstance();
      for(int i=0;i<100*100*100;i++) {
        //Tangshi ts = new Tangshi();

        PropertyUtils.setSimpleProperty(ts, "title", "AAAAAAAAAA");
        s=((String) PropertyUtils.getSimpleProperty(ts, "title"));


      } } catch (IllegalAccessException e) {
      e.printStackTrace();
    } catch (InvocationTargetException e) {
      e.printStackTrace();
    } catch (NoSuchMethodException e) {
      e.printStackTrace();
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    } catch (InstantiationException e) {
      e.printStackTrace();
    }
    System.out.println("耗时："+(System.currentTimeMillis()-start));  //547

    start=System.currentTimeMillis();
    //ts = new Tangshi();
    s="";

    try {
      Class<?> managerClass = Class.forName(clsname);
      Object obj = managerClass.newInstance();
      for(int i=0;i<1;i++) {



        Field field=managerClass.getDeclaredField("title");
        field.setAccessible(true);
        field.set(obj,"AAAAAAAAAA");
        //PropertyUtils.setSimpleProperty(ts, "title", "title");
        Field field2=managerClass.getDeclaredField("author");
        field2.setAccessible(true);
        s=   (String) field2.get(obj); //((String) PropertyUtils.getSimpleProperty(ts, "title"));
         System.out.println("ss "+s);

      } } catch (IllegalAccessException e) {
      e.printStackTrace();
    }   catch (NoSuchFieldException e) {
      e.printStackTrace();
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    } catch (InstantiationException e) {
      e.printStackTrace();
    }
    System.out.println("耗时2："+(System.currentTimeMillis()-start)); //280

  }

  static void sc2sqlite(){

    int cnt = 0;
    boolean bstmt=false;
    String database = "y:/temp/ci.db";//"E:\\CBDBDatabase\\tangshi.sqlite";
    String sql;
    if(bstmt==false) {
      //sql = "insert into tangshi(author,title,paragraphs,strains) values (?,?,?,?)";
      sql = "REPLACE INTO ci(author,rhythmic,content,pyquany,pyjian,pyquan,value) values (?,?,?,?,?,?,?)";
    }
    else
      sql = "insert into tangshi(author,title,paragraphs,strains) values ('%s','%s','%s','%s')";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    long start = System.currentTimeMillis();
    int count=0;
    try {
      //Class.forName("org.sqlite.jdbc");
      conn = DriverManager.getConnection("jdbc:sqlite:" + database);
      conn.setAutoCommit(false);  //设为手动提交

      if(bstmt)
        stmt = conn.createStatement(); //计时：17360 条数：311828
      else
        ps = conn.prepareStatement(sql); //计时：15640 条数：311828


      String sqll = "SELECT value,\n"
          + "       rhythmic,\n"
          + "       author,\n"
          + "       content,\n"
          + "       pyquan,\n"
          + "       pyjian,\n"
          + "       pyquany\n"
          + "  FROM ci;";
      stmt = conn.createStatement();
      ResultSet rsr = stmt.executeQuery(sqll);

      while(rsr.next()){



          if(bstmt==false) {
            String ftName= rsr.getString("author");
            ps.setString(1, rsr.getString("author") );
            ps.setString(2, rsr.getString("rhythmic") );
            ps.setString(3, rsr.getString("content") );
            ps.setString(4, getQpY(ftName) );
            ps.setString(5, getJp(ftName) );
             ps.setString(6, getQp(ftName) );
            ps.setString(7, rsr.getString("value") );
            //ps.setBytes(1,ftName.getBytes("UTF-16LE")); //体积91M
            //ps.setBytes(2, tsBean.getTitle().getBytes("UTF-16LE"));
            //ps.setBytes(3, paragraphs.getBytes("UTF-16LE"));
            //ps.setBytes(4, strains.getBytes("UTF-16LE"));
            //ps.setBytes(5, getQp(ftName).getBytes("UTF-16LE"));
            //ps.setBytes(6, getJp(ftName).getBytes("UTF-16LE"));
            //ps.setBytes(7, HanLP.convertToSimplifiedChinese(ftName).getBytes("UTF-16LE"));
            ps.addBatch();
          }else {
            //  sqll =
            //    String.format(sql, tsBean.getAuthor(), tsBean.getTitle(), paragraphs, strains);
            //
            //stmt.addBatch(sqll);
          }
          count++;
          //System.out.println(sqll);
          //if(lststrains.contains(strains)==false) {
          //  System.out.println("strains :"+cnt+"  " + strains);
          //  lststrains.add(strains);
          //}
          //cnt++;
        }


      if(bstmt==false) {
        int[] ret = ps.executeBatch();
        conn.commit();  //提交事务
        ps.clearBatch();
      }else {
        stmt.executeBatch();
        conn.commit();  //提交事务
        stmt.clearBatch();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    long t2 = System.currentTimeMillis();
    System.out.println("计时："+(t2-start)+" 条数："+count);
  }


  static void ts2sqlite(){
    Gson gson = new Gson();

    String path = "Y:\\yyyy\\chinese-poetry\\json";

    String[] jsonfiles = new File(path).list();
    int cnt = 0;
    boolean bstmt=false;
    String database = "y:/temp/tangshi.sqlite";//"E:\\CBDBDatabase\\tangshi.sqlite";
    String sql;
    if(bstmt==false) {
      //sql = "insert into tangshi(author,title,paragraphs,strains) values (?,?,?,?)";
      sql = "REPLACE INTO tangshi(author,title,paragraphs,strains,pyquany,pyjian,authorjt,pyquan) values (?,?,?,?,?,?,?,?)";
    }
    else
      sql = "insert into tangshi(author,title,paragraphs,strains) values ('%s','%s','%s','%s')";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    long start = System.currentTimeMillis();
    int count=0;
    try {
      //Class.forName("org.sqlite.jdbc");
      conn = DriverManager.getConnection("jdbc:sqlite:" + database);
      conn.setAutoCommit(false);  //设为手动提交

      if(bstmt)
        stmt = conn.createStatement(); //计时：17360 条数：311828
      else
        ps = conn.prepareStatement(sql); //计时：15640 条数：311828


      for (int i = 0; i < jsonfiles.length; i++) {
        //System.out.println(jsonfiles[i]);
        if(jsonfiles[i].indexOf("poet.tang")<0)
          continue;
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

          if(bstmt==false) {
            String ftName= tsBean.getAuthor();

            //ps.setString(1, tsBean.getAuthor());
            //ps.setString(2, tsBean.getTitle());
            //ps.setString(3, paragraphs);
            //ps.setString(4, strains); //体积137M

            ps.setString(1,ftName ); //体积91M
            ps.setString(2, tsBean.getTitle() );
            ps.setString(3, paragraphs );
            ps.setString(4, strains );
            ps.setString(5, getQpY(ftName) );
            ps.setString(6, getJp(ftName) );
            ps.setString(7, HanLP.convertToSimplifiedChinese(ftName) );
            ps.setString(8, getQp(ftName) );
            //ps.setBytes(1,ftName.getBytes("UTF-16LE")); //体积91M
            //ps.setBytes(2, tsBean.getTitle().getBytes("UTF-16LE"));
            //ps.setBytes(3, paragraphs.getBytes("UTF-16LE"));
            //ps.setBytes(4, strains.getBytes("UTF-16LE"));
            //ps.setBytes(5, getQp(ftName).getBytes("UTF-16LE"));
            //ps.setBytes(6, getJp(ftName).getBytes("UTF-16LE"));
            //ps.setBytes(7, HanLP.convertToSimplifiedChinese(ftName).getBytes("UTF-16LE"));
            ps.addBatch();
          }else {
            String sqll =
                String.format(sql, tsBean.getAuthor(), tsBean.getTitle(), paragraphs, strains);

            stmt.addBatch(sqll);
          }
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
      if(bstmt==false) {
        int[] ret = ps.executeBatch();
        conn.commit();  //提交事务
        ps.clearBatch();
      }else {
        stmt.executeBatch();
        conn.commit();  //提交事务
        stmt.clearBatch();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    long t2 = System.currentTimeMillis();
    System.out.println("计时："+(t2-start)+" 条数："+count);
  }
  static String getQpY(String s){
    List<Pinyin> pinyinList;
    pinyinList = HanLP.convertToPinyinList(s) ;
    String pyName="";
    for (Pinyin pinyin : pinyinList)
    {
      pyName+= upOne(pinyin.getPinyinWithToneMark());
    }
    return pyName;
  }
  static String getQp(String s){
    List<Pinyin> pinyinList;
    pinyinList = HanLP.convertToPinyinList(s) ;
    String pyName="";
    for (Pinyin pinyin : pinyinList)
    {
      pyName+= upOne(pinyin.getPinyinWithoutTone());
    }
    return pyName;
  }

  static String getJp(String s){
    List<Pinyin> pinyinList;
    pinyinList = HanLP.convertToPinyinList(s) ;
    String pyName="";
    for (Pinyin pinyin : pinyinList)
    {
      pyName+= pinyin.getPinyinWithToneMark().charAt(0);
    }
    System.out.println(pyName);
    return pyName;
  }

  //首字母转大写
  //public static String upOne(String s){
  //  if(Character.isUpperCase(s.charAt(0)))
  //    return s;
  //  else
  //    return (new StringBuilder()).append(Character.toUpperCase(s.charAt(0))).append(s.substring(1)).toString();
  //}
  public static String upOne(String str)
  {
    return str.replaceFirst(str.substring(0, 1),str.substring(0, 1).toUpperCase()) ;
  }
}
