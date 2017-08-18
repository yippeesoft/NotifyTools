package org.github.yippee.china_poem.Test;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import org.apache.commons.beanutils.PropertyUtils;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.Utils.LogUtils;

/**
 * Created by sf on 2017/8/18.
 */

public class TestBeanUtils {
  LogUtils log=LogUtils.getLogger(TestBeanUtils.class);
  void testBean(){
    long start=System.currentTimeMillis();

    String s;
    try {
      Class<?> managerClass = Class.forName("org.github.yippee.china_poem.poem2db.bean.Tangshi");
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
