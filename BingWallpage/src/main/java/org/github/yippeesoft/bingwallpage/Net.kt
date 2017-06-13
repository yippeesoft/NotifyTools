package org.github.yippeesoft.bingwallpage


import android.util.Log
import com.orhanobut.logger.Logger
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.functions.Function
import io.reactivex.schedulers.Schedulers
import okhttp3.Cache
import okhttp3.CacheControl
import okhttp3.Interceptor
import okhttp3.Interceptor.Chain
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import okhttp3.ResponseBody
import org.dom4j.Document
import org.dom4j.DocumentHelper
import org.dom4j.Element
import org.dom4j.Node
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.converter.simplexml.SimpleXmlConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import retrofit2.http.Url
import java.util.concurrent.TimeUnit
import org.simpleframework.xml.core.Persister
import org.simpleframework.xml.convert.AnnotationStrategy
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory


/**
 * Created by sf on 2017/6/8.
 */
class Net {
  val BASE_URL: String = "http://cn.bing.com/"

  data class BingWallBean(val url:String,val copyright:String)

  fun getBingWall():Observable<List<BingWallBean>>{
    var retrofit=BaseRetrofit.retrofit(BASE_URL)
    var netService:NetService=retrofit.create(NetService::class.java)
    return netService.getWallList("/HPImageArchive.aspx?format=xml",0,20)

        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .flatMap(Function<retrofit2.Response<ResponseBody>,Observable<List<BingWallBean>>?> {
            rep->
          var beans = mutableListOf<BingWallBean>()
            if(rep!=null && !rep.isSuccessful){
              Logger.d(rep.errorBody().toString())
            }
          if (rep != null && rep.body() != null){
            val resp = rep.body()!!.string()
            Logger.d("body:" + resp)
            val strategy = AnnotationStrategy()
            val serializer = Persister(strategy)
//            var wall:BingWallBean =serializer.read(BingWallBean::class.java,resp)
            val document: Document = DocumentHelper.parseText(resp)
            val xpath:String="images/image"
            val nodes:List<Node> = document.selectNodes(xpath)


            for (n in nodes){
              val e:Element = n as Element
              val b:BingWallBean =BingWallBean(e.element("url").text,e.element("copyright").text)
              beans.add(b)
//              Logger.d("node "+e.element("url").text)
            }
//            Observable.just<BingWallBean>(wall)
          }
           Observable.just(beans)
        })

  }
  
}

fun Net.add(){
  Logger.d("测试")
}
interface NetService {
  @GET
  fun getWallList(@Url url:String,@Query("idx")idx:Int,@Query("n")n:Int): Observable<retrofit2.Response<ResponseBody>>

}


object BaseRetrofit {
  private const val cacheSize: Long = 10 * 1024 * 1024
//
//  var interceptor = Interceptor {
//    //获取原始Request对象，并在原始Request对象的基础上增加请求头信息
//    val request = it.request().newBuilder()
//        .addHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
//        .addHeader("Accept-Language", "zh-CN,zh;q=0.8,en;q=0.6")
//        .addHeader("Connection", "keep-alive")
//        .build()
//    //执行请求并返回响应对象
//    it.proceed(request)
//  }
//
// var test  =Interceptor{
//
//   val response =it.proceed(it.request())
//   response
//  }

  private var REWRITE_CACHE_CONTROL_INTERCEPTOR: Interceptor = Interceptor {
    chain ->
    val response = chain?.proceed(chain.request())
    if (App.isNetOk()) {
      val maxAge: Int = 0
      response?.newBuilder()!!.removeHeader("Cache-Control")
          .removeHeader("Pragma")
          .header("Cache-Control", "public, max-age=" + maxAge)
          .build()
    } else {
      val maxAge = 60 * 60 * 24 * 7
      response?.newBuilder()!!.removeHeader("Cache-Control")
          .removeHeader("Pragma")
          .header("Cache-Control", "public, only-if-cached, max-stale=" + maxAge)
          .build()
    }
  }

  private fun getClient(): OkHttpClient {
    val builder = OkHttpClient.Builder()
    if (builder.interceptors() != null) {
      builder.interceptors().clear()
    }

    builder.addInterceptor { chain ->
      val request = chain?.request()
      if (!App.isNetOk()) {
        chain!!.proceed(request!!
            .newBuilder()
            .cacheControl(CacheControl.FORCE_CACHE)
            .build())
      } else {
        chain!!.proceed(
            request!!.newBuilder().build())
      }
    }.addNetworkInterceptor(REWRITE_CACHE_CONTROL_INTERCEPTOR)
        .cache(Cache(App.getContext().cacheDir, cacheSize))
        .connectTimeout(10, TimeUnit.SECONDS)
        .writeTimeout(20, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
    return builder.build()
  }


  fun retrofit(url: String): Retrofit {
    val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(url)
        .client(getClient())
        .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
        .addConverterFactory(GsonConverterFactory.create())
        .addConverterFactory(SimpleXmlConverterFactory.create())
        .build()
    return retrofit
  }
}