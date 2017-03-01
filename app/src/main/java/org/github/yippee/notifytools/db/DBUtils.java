package org.github.yippee.notifytools.db;

import android.content.Context;
import android.content.ContextWrapper;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;

import org.github.yippee.notifytools.MainApp;
import org.github.yippee.notifytools.db.greendaogen.DaoMaster;
import org.github.yippee.notifytools.db.greendaogen.DaoSession;
import org.github.yippee.notifytools.utils.PathUtils;

import java.io.File;
import java.io.IOException;


/**
 * Created by sf on 2017/2/28.
 */

public class DBUtils {
    private DaoMaster.DevOpenHelper mHelper;
    private SQLiteDatabase db;
    private DaoMaster mDaoMaster;
    private DaoSession mDaoSession;
    static DBUtils dbUtils=null;
    private DBUtils(){

    }
    public static DBUtils getSingleTon(){
        if(dbUtils==null)
            dbUtils=new DBUtils();

        return dbUtils;
    }
    /**
     * 设置greenDao
     */
    public void setDatabase() {
        // 通过 DaoMaster 的内部类 DevOpenHelper，你可以得到一个便利的 SQLiteOpenHelper 对象。
        // 可能你已经注意到了，你并不需要去编写「CREATE TABLE」这样的 SQL 语句，因为 greenDAO 已经帮你做了。
        // 注意：默认的 DaoMaster.DevOpenHelper 会在数据库升级时，删除所有的表，意味着这将导致数据的丢失。
        // 所以，在正式的项目中，你还应该做一层封装，来实现数据库的安全升级。
//        mHelper = new DaoMaster.DevOpenHelper(MainApp.getApplication(), "testdb", null);
        mHelper = new DaoMaster.DevOpenHelper(new GreenDaoContext(), "appdb", null);
        db = mHelper.getWritableDatabase();
        // 注意：该数据库连接属于 DaoMaster，所以多个 Session 指的是相同的数据库连接。
        mDaoMaster = new DaoMaster(db);
        mDaoSession = mDaoMaster.newSession();
    }
    public void setDatabase(Context cxt) {
        // 通过 DaoMaster 的内部类 DevOpenHelper，你可以得到一个便利的 SQLiteOpenHelper 对象。
        // 可能你已经注意到了，你并不需要去编写「CREATE TABLE」这样的 SQL 语句，因为 greenDAO 已经帮你做了。
        // 注意：默认的 DaoMaster.DevOpenHelper 会在数据库升级时，删除所有的表，意味着这将导致数据的丢失。
        // 所以，在正式的项目中，你还应该做一层封装，来实现数据库的安全升级。
        mHelper = new DaoMaster.DevOpenHelper(cxt, "testdb", null);
        db = mHelper.getWritableDatabase();
        // 注意：该数据库连接属于 DaoMaster，所以多个 Session 指的是相同的数据库连接。
        mDaoMaster = new DaoMaster(db);
        mDaoSession = mDaoMaster.newSession();
    }
    public DaoSession getDaoSession() {
        return mDaoSession;
    }
    public SQLiteDatabase getDb() {
        return db;
    }

    class GreenDaoContext extends ContextWrapper {

        private Context mContext;

        public GreenDaoContext() {
            super(MainApp.getApplication());
            this.mContext = MainApp.getApplication();
//        this.currentUserId = "greendao";//初始化
        }

        /**
         * 获得数据库路径，如果不存在，则创建对象
         *
         * @param name
         */
        @Override
        public File getDatabasePath(String name) {
            String dbDir = PathUtils.getDbPath();
            if (!name.endsWith(".db")) {
                name += ".db";
            }
            File result =new File(dbDir+File.separator+name);
            if (!result.getParentFile().exists()) {
                result.getParentFile().mkdirs();
            }
            try {
                if(result.exists()) result.delete();
                result.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
                result = super.getDatabasePath(name);
            }
            return result;
        }

        /**
         * 重载这个方法，是用来打开SD卡上的数据库的，android 2.3及以下会调用这个方法。
         *
         * @param name
         * @param mode
         * @param factory
         */
        @Override
        public SQLiteDatabase openOrCreateDatabase(String name, int mode,
                                                   SQLiteDatabase.CursorFactory factory) {
            SQLiteDatabase result = SQLiteDatabase.openOrCreateDatabase(getDatabasePath(name), factory);
            return result;
        }

        /**
         * Android 4.0会调用此方法获取数据库。
         *
         * @param name
         * @param mode
         * @param factory
         * @param errorHandler
         * @see android.content.ContextWrapper#openOrCreateDatabase(java.lang.String, int,
         * android.database.sqlite.SQLiteDatabase.CursorFactory,
         * android.database.DatabaseErrorHandler)
         */
        @Override
        public SQLiteDatabase openOrCreateDatabase(String name, int mode, SQLiteDatabase.CursorFactory factory,
                                                   DatabaseErrorHandler errorHandler) {
            SQLiteDatabase result = SQLiteDatabase.openOrCreateDatabase(getDatabasePath(name), factory);

            return result;
        }

    }
}
