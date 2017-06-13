package org.github.yippeesoft.bingwallpage

import android.app.Application
import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo
import com.orhanobut.logger.AndroidLogAdapter
import com.orhanobut.logger.Logger

/**
 * Created by sf on 2017/6/8.
 */
class App:Application(){
  object C {
    lateinit var context: Context
  }
  val TAG:String="App"
  override fun onCreate() {
    super.onCreate()
    C.context=applicationContext
    Logger.addLogAdapter(AndroidLogAdapter())

    Logger.d(TAG,"onCreate")
  }

  companion object{
    fun getContext():Context{
      return C.context
    }

    fun isNetOk():Boolean{
      val con:ConnectivityManager=getContext().getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
      val netWorkInfo:NetworkInfo?=con.activeNetworkInfo
      return netWorkInfo!=null && netWorkInfo.isConnected
    }
  }

}

