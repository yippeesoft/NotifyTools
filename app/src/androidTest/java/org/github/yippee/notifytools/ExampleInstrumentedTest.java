package org.github.yippee.notifytools;

import android.content.Context;
import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;

import org.github.yippee.notifytools.db.DBUtils;
import org.github.yippee.notifytools.db.greendao.UserDao;
import org.github.yippee.notifytools.db.test.User;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;

/**
 * Instrumentation test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class ExampleInstrumentedTest {
    @Test
    public void useAppContext() throws Exception {
        // Context of the app under test.
        Context appContext = InstrumentationRegistry.getTargetContext();

        assertEquals("org.github.yippee.notifytools", appContext.getPackageName());
    }
    @Test
    public void dbTest(){
        Context appContext = InstrumentationRegistry.getTargetContext();
        DBUtils.getSingleTon().setDatabase(appContext);
        UserDao dao=DBUtils.getSingleTon().getDaoSession().getUserDao();

//        User insertData=new User(null,"AAAAAAA");
//        dao.insert(insertData);
//
//        System.out.println(dao.load(21L).toString()+" "+dao.loadAll().size());
//        insertData=new User(null,"BBBBBBB");
//        dao.insert(insertData);

//        for(User u:dao.loadAll())
//            System.out.println("TTTT1 "+u.toString());
//        dao.delete(new User(22L,"AAAAAAA"));
        User user=new User(21L,"YYYYYYYYY");
        dao.update(user);

        for(User u:dao.loadAll())
            System.out.println("TTTT2 "+u.toString());


    }
}
