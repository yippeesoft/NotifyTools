package org.github.yippee.tangshi;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * Created by sf on 2017/7/25.
 */

public class Ts2Sqlite {

  public static void main(String[] args) {
    Gson gson = new Gson();

    String path = "Y:\\yyyy\\chinese-poetry\\json";

    String[] jsonfiles = new File(path).list();
    int cnt = 0;
    boolean bstmt=false;
    String database = "y:/temp/tangshi.sqlite";//"E:\\CBDBDatabase\\tangshi.sqlite";
    String sql;
    if(bstmt==false) {
      //sql = "insert into tangshi(author,title,paragraphs,strains) values (?,?,?,?)";
      sql = "REPLACE INTO tangshi(author,title,paragraphs,strains) values (?,?,?,?)";
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
            //ps.setString(1, tsBean.getAuthor());
            //ps.setString(2, tsBean.getTitle());
            //ps.setString(3, paragraphs);
            //ps.setString(4, strains); //体积137M
            ps.setBytes(1, tsBean.getAuthor().getBytes("UTF-16LE")); //体积91M
            ps.setBytes(2, tsBean.getTitle().getBytes("UTF-16LE"));
            ps.setBytes(3, paragraphs.getBytes("UTF-16LE"));
            ps.setBytes(4, strains.getBytes("UTF-16LE"));
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
}
