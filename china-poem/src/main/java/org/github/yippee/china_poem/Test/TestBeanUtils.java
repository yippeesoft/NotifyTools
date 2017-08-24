package org.github.yippee.china_poem.Test;

import android.text.TextUtils;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.google.common.collect.Maps;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.beanutils.PropertyUtils;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.Utils.LogUtils;
import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;
import org.luaj.vm2.lib.jse.JsePlatform;
import org.mvel2.MVEL;

/**
 * Created by sf on 2017/8/18.
 */

public class TestBeanUtils {
  static LogUtils log=LogUtils.getLogger(TestBeanUtils.class);
  public static void testLuaj(){
    Globals globals = JsePlatform.standardGlobals();
    LuaValue chunk = globals.load("print 'hello, world'");
    chunk.call();
    chunk = globals.load("local x=100 \n return x*5 * 10");
    if (!chunk.isnil())
      try {
        log.e(chunk.call().toint()+"lua");//      .call(CoerceJavaToLua.coerce("")).toboolean());
      } catch (Exception e) {
        e.printStackTrace();

      }


  }
  public static void testMvel(){
    //Map<String, Object> params = new HashMap<String, Object>();
    //params.put("x", 10);
    //params.put("y", 20);
    //Object result = MVEL.eval("x+y", params);
    List<Integer> lst=new ArrayList<>();
    for(int i=0;i<10*100*100;i++){
      lst.add(i);
    }
    Map<String, Object> input = new HashMap<String, Object>();
    input.put("AA",lst);
    //Object result = MVEL.eval(" val v=0;for(x:lst) { v=v+x;} return v;", lst);
    //Object result = MVEL.eval(" foreach (x : AA) { System.out.println(x+\"\");} return 0;", input);
    Object result = MVEL.eval("  foreach (x : AA) { System.out.println(x+1000);} return 0;", input);
    //打印到51，然后 Error: can't load this type of class file

    log.e("AAAA:"+result);
  }

  void testGuava(){
    List<HashMap<String, String>> records = new ArrayList<HashMap<String, String>>();

    int maxx=50*100*100;
    for(int i=0;i<maxx;i++){
      HashMap<String,String>   map=new HashMap<String,String>();
      map.put(i+"AA",i+"BB");
      records.add(map);
    }
    long start=System.currentTimeMillis();
    final Long[] l = new Long[1];
    l[0]=0L;
    Predicate<HashMap<String, String>> predicate = new Predicate<HashMap<String, String>>() {
      @Override
      public boolean apply(HashMap<String, String> input) {
        Map<String, String> map = Maps.filterValues(input, new Predicate<String>() {
          @Override
          public boolean apply(String person) {
            if(TextUtils.isEmpty(person))
              return false;
            int kk=Integer.valueOf(person.substring(0,person.length()-2));
            l[0] = l[0] + kk;
            return kk  >= 9*100*100;
          }
        });
        return map.size()>0;
      }
    };

    Collection<HashMap<String, String>> result = Collections2.filter(records, predicate);
    //List<HashMap<String, String>> result=new ArrayList<HashMap<String, String>>();
    //for(int i=0;i<maxx;i++){
    //  HashMap<String, String> map=records.get(i);
    //  HashMap<String, String> mapp=new HashMap<String, String>();
    //  //for(String keyy:map.keySet()){
    //  //  String str=map.get(keyy);
    //  //  int kk=Integer.valueOf(str.substring(0,str.length()-2));
    //  //  if(kk >= 9*100*100){
    //  //    mapp.put(keyy,str);
    //  //  }
    //  //}
    //  for (Map.Entry<String, String> entry : map.entrySet()) {
    //      String str=entry.getValue();
    //      int kk=Integer.valueOf(str.substring(0,str.length()-2));
    //      if(kk >= 9*100*100){
    //        mapp.put(entry.getKey(),entry.getValue());
    //      }
    //  }
    //  if(mapp.size()>0)
    //    result.add(mapp);
    //}
    log.d("end "+(System.currentTimeMillis()-start)+"  "+result.size()+" "+l[0]);
    //for(HashMap<String,String> kk : result){
    //
    //}
  }
  public void testBean(){
    long start=System.currentTimeMillis();

    String s;
    try {
      Class<?> managerClass = Class.forName("org.github.yippee.china_poem.poem2db.bean.Tangshi");
      Object ts = managerClass.newInstance();
      for(int i=0;i<100*100*100;i++) {
        //Tangshi ts = new Tangshi();

        PropertyUtils.setSimpleProperty(ts, "title", "AAAAAAAAAA");
        s=(  PropertyUtils.getSimpleProperty(ts, "title").toString());


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
    log.e("耗时："+(System.currentTimeMillis()-start));  //7064

    start=System.currentTimeMillis();
    //ts = new Tangshi();
    s="";
    try {
      Class<?> managerClass = Class.forName("org.github.yippee.china_poem.poem2db.bean.Tangshi");
      Object obj = managerClass.newInstance();
      for(int i=0;i<1;i++) {
        Field field=managerClass.getDeclaredField("title");
        field.setAccessible(true);
        field.set(obj,"AAAAAAAAAA");
        //PropertyUtils.setSimpleProperty(ts, "title", "title");
        Field field2=managerClass.getDeclaredField("author");
        field.setAccessible(true);
        s=   (String) field.get(obj); //((String) PropertyUtils.getSimpleProperty(ts, "title"));
        log.e("ss "+s);

      } } catch (IllegalAccessException e) {
      e.printStackTrace();
    }   catch (NoSuchFieldException e) {
      e.printStackTrace();
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    } catch (InstantiationException e) {
      e.printStackTrace();
    }
    log.e("耗时2："+(System.currentTimeMillis()-start));  //5964

  }

}
