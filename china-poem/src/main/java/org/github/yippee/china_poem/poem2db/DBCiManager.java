package org.github.yippee.china_poem.poem2db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import org.github.yippee.china_poem.poem2db.dao.gen.DaoSession;
import org.github.yippee.china_poem.poem2db.dao.gen.SongCiDao;
import org.github.yippee.china_poem.poem2db.dao.gen.TangshiDao;

/**
 * Created by sf on 2017/7/20.
 */

public class DBCiManager {
  private final static String dbName = "/sdcard/ci.db";
  private static DBCiManager mInstance;
  private DaoDBMaster.DevOpenHelper openHelper;
  private Context context;

  public DBCiManager(Context context) {
    this.context = context;
    openHelper = new DaoDBMaster.DevOpenHelper(context, dbName, null);

  }

  /**
   * 获取单例引用
   *
   * @param context
   * @return
   */
  public static DBCiManager getInstance(Context context) {
    if (mInstance == null) {
      synchronized (DBCiManager.class) {
        if (mInstance == null) {
          mInstance = new DBCiManager(context);
        }
      }
    }
    return mInstance;
  }


  /**
   * 获取可读数据库
   */
  private SQLiteDatabase getReadableDatabase() {
    if (openHelper == null) {
      openHelper = new DaoDBMaster.DevOpenHelper(context, dbName, null);
    }
    SQLiteDatabase db = openHelper.getReadableDatabase();
    return db;
  }

  /**
   * 获取可写数据库
   */
  private SQLiteDatabase getWritableDatabase() {
    if (openHelper == null) {
      openHelper = new DaoDBMaster.DevOpenHelper(context, dbName, null);
    }
    SQLiteDatabase db = openHelper.getWritableDatabase();
    return db;
  }

  public SongCiDao getSongCiDao( ) {
    DaoDBCiMaster DaoDBMaster = new DaoDBCiMaster(getWritableDatabase());
    DaoSession daoSession = DaoDBMaster.newSession();
    SongCiDao userDao = daoSession.getSongCiDao();
    return userDao ;
  }

  public DaoSession getDaoSession( ) {
    DaoDBCiMaster DaoDBMaster = new DaoDBCiMaster(getWritableDatabase());
    DaoSession daoSession = DaoDBMaster.newSession();

    return daoSession ;
  }

  //
  //public void insertUserList(List<Test> users) {
  //  if (users == null || users.isEmpty()) {
  //    return;
  //  }
  //  DaoDBMaster DaoDBMaster = new DaoDBMaster(getWritableDatabase());
  //  DaoSession daoSession = DaoDBMaster.newSession();
  //  TestDao userDao = daoSession.getTestDao();
  //  userDao.insertInTx(users);
  //}
  //
  //public void deleteUser(Test user) {
  //  DaoDBMaster DaoDBMaster = new DaoDBMaster(getWritableDatabase());
  //  DaoSession daoSession = DaoDBMaster.newSession();
  //  TestDao userDao = daoSession.getTestDao();
  //  userDao.delete(user);
  //}
  //
  //public void updateUser(Test user) {
  //  DaoDBMaster DaoDBMaster = new DaoDBMaster(getWritableDatabase());
  //  DaoSession daoSession = DaoDBMaster.newSession();
  //  TestDao userDao = daoSession.getTestDao();
  //  userDao.update(user);
  //}
  //
  ///**
  // * 查询用户列表
  // */
  //public List<Test> queryUserList() {
  //  DaoDBMaster DaoDBMaster = new DaoDBMaster(getReadableDatabase());
  //  DaoSession daoSession = DaoDBMaster.newSession();
  //  TestDao userDao = daoSession.getTestDao();
  //  QueryBuilder<Test> qb = userDao.queryBuilder();
  //  List<Test> list = qb.list();
  //  return list;
  //}
  //
  ///**
  // * 查询用户列表
  // */
  //public List<Test> queryUserList(int age) {
  //  DaoDBMaster DaoDBMaster = new DaoDBMaster(getReadableDatabase());
  //  DaoSession daoSession = DaoDBMaster.newSession();
  //  TestDao userDao = daoSession.getTestDao();
  //  QueryBuilder<Test> qb = userDao.queryBuilder();
  //  qb.where(TestDao.Properties.A.gt(age)).orderAsc(TestDao.Properties.A);
  //  List<Test> list = qb.list();
  //  return list;
  //}
}