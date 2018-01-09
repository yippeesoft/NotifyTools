package org.github.yippee.notifytools.java;


import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.XPath;
import org.github.yippee.notifytools.service.StringConverterFactory;

import org.github.yippee.notifytools.utils.Logs;
import org.htmlparser.Node;
import org.htmlparser.Parser;
import org.htmlparser.filters.AndFilter;
import org.htmlparser.filters.HasAttributeFilter;
import org.htmlparser.filters.NodeClassFilter;
import org.htmlparser.filters.TagNameFilter;
import org.htmlparser.tags.LinkTag;
import org.htmlparser.tags.Span;
import org.htmlparser.util.NodeList;


import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;


import io.reactivex.Observable;
import io.reactivex.annotations.NonNull;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;
import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Response;
import retrofit2.Retrofit;
//import retrofit2.adapter.rxjava.RxJavaCallAdapterFactory;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Url;
//import rx.Observable;
//import rx.android.schedulers.AndroidSchedulers;
//import rx.functions.Action0;
//import rx.functions.Action1;
//import rx.functions.Func1;
//import rx.schedulers.Schedulers;

/**
 * Created by sf on 2017/2/24.
 */

public class WardService {
    private Logs log = Logs.getLogger(this.getClass());

    String baseUrl = "http://www.xzqh.org/html/";

    Retrofit retrofit;
    OkHttpClient okHttpClient;
    IWardService wardService;

    // 创建DOM工厂对象
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

    public interface IWardService {
        //        @Headers({"Content-Type: application/json", "Accept: application/json"})
        @GET
        Observable<Response<ResponseBody>> getWard(@Url String url);
    }

    public WardService() {
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        okHttpClient = new OkHttpClient.Builder()
//                .readTimeout(5, TimeUnit.SECONDS)//设置读取超时时间
//                .writeTimeout(5,TimeUnit.SECONDS)//设置写的超时时间
//                .connectTimeout(5,TimeUnit.SECONDS)//设置连接超时时间
//                .addInterceptor(interceptor)
                .build();
        retrofit = new Retrofit.Builder()
                .baseUrl(baseUrl)
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .addConverterFactory(StringConverterFactory.create())
                .client(okHttpClient)
                .build();
        wardService = retrofit.create(IWardService.class);
    }

    public void getWard() {
        String url = baseUrl + "sitemap.html";
        log.d(url);
        wardService.getWard(url).subscribeOn(Schedulers.io())
                .flatMap(new Function<Response<ResponseBody>, Observable<String>>() {
                    @Override
                    public Observable<String> apply(@NonNull Response<ResponseBody> response) throws Exception {
                        String resp = null;
                        if (response != null && !response.isSuccessful()) {
                            try {
                                log.d(response.errorBody().string());
                            } catch (IOException e) {
                                log.e(e);
                            }
                        }
                        if (response != null && response.body() != null) {
                            try {
                                resp =new String(  response.body().bytes(),"GBK");;
//                                resp = new String(resp.getBytes("UTF-8"),"GBK");
//                                log.d("resp：" + resp);
                            } catch (IOException e) {
                                log.e(e);
                            }
                        }
                        return Observable.just(resp);
                    } })



                .observeOn(Schedulers.computation())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String resp) throws Exception {
                        log.d("onnext：" + resp);
                        // DocumentBuilder对象


                        try {
                            Parser htmlParser = Parser.createParser(resp, "UTF-8");
                            // 获取指定的 div 节点，即 <div> 标签，并且该标签包含有属性 id 值为“tab1”
                            NodeList divOfTab1 = htmlParser.extractAllNodesThatMatch(
                                    new AndFilter(new TagNameFilter("div"), new HasAttributeFilter("id", "site_map")));
                            int iSheng=1;
                            int iShi=0;
                            boolean bSheng=false;
                            if (divOfTab1 != null && divOfTab1.size() > 0) {
                                NodeList itemLiList = divOfTab1.elementAt(0).getChildren();
                                for (int i =2; i < itemLiList.size(); i++) {
                                    String sH3=itemLiList.elementAt(i).getText();
//                                    log.d("itemLiList.elementAt(i):"+sH3);
                                    Node node=itemLiList.elementAt(i);
                                    NodeList nodelst=node.getChildren();
                                    if(sH3!=null && sH3.equalsIgnoreCase("h3")){
                                        LinkTag lt= (LinkTag) nodelst.elementAt(0);
                                        log.d("省地区："+iSheng+" "+lt.getLinkText());
                                        iSheng++;
                                        iShi=0;
                                        bSheng=true;
                                    }
                                    if(sH3!=null && sH3.equalsIgnoreCase("ul")){
                                        if(nodelst!=null && nodelst.size()>0) {
                                            NodeList aS =  nodelst.elementAt(0).getChildren().extractAllNodesThatMatch(new TagNameFilter("a"));
                                            if(aS.elementAt(0)!=null) {
                                                LinkTag ltt= (LinkTag) aS.elementAt(0);
                                                iShi++;
                                                log.d("市a：" + iShi + " " + ltt.getLinkText());
                                            }else{
                                                aS =  nodelst.elementAt(0).getChildren().extractAllNodesThatMatch(new TagNameFilter("span"));
                                                if(aS.elementAt(0)!=null) {
                                                    Node nn= aS.elementAt(0).getChildren().elementAt(0);
                                                    if(nn instanceof LinkTag) {
                                                        LinkTag ltt = (LinkTag) aS.elementAt(0).getChildren().elementAt(0);
                                                        iShi++;
                                                        log.d("市span：" + iShi + " " + ltt.getStringText().trim());
                                                    }
                                                }
                                            }
                                            for(int k=1;k<nodelst.size();k++){
                                                Node nodek=nodelst.elementAt(k);
                                                if(nodek.getChildren()!=null && nodek.getChildren().elementAt(0)!=null){
                                                    if(nodek.getChildren().elementAt(0) instanceof LinkTag) {
                                                        LinkTag ltk = (LinkTag)nodek.getChildren().elementAt(0);
                                                        log.d("区县：" + ltk.getLinkText());
                                                    }else{
                                                        log.d("区县：" + nodek.getChildren().elementAt(0).getText());
                                                    }
                                                }

                                            }
//                                            iSheng++;
//                                            bSheng = false;
                                        }
                                    }
//                                    if(itemLiList.elementAt(i).getChildren()!=null) {
//                                        NodeList h3Item = itemLiList.elementAt(i).getChildren().extractAllNodesThatMatch
//                                                ( new TagNameFilter("h3") );
//
//                                        log.d("h3Item text :"+ ((LinkTag)h3Item.elementAt(0)).getLinkText());
////                                        for (int j = 0; j < h3Item.size(); j++) {
////                                            if(h3Item.elementAt(j).getChildren()!=null) {
////                                                NodeList aItem = h3Item.elementAt(j).getChildren().extractAllNodesThatMatch(new TagNameFilter("a"));
////                                                if(aItem!=null && aItem.elementAt(0)!=null)
////                                                log.d("h3Item:" + aItem.elementAt(0).getText());
////                                            }
////                                        }
//                                    }
                                }

                            }
//                            org.dom4j.Document dh;
//                            dh = DocumentHelper.parseText(resp);
//                            Element root = dh.getRootElement();
//                            log.d("onnext DocumentHelper：");
//                            XPath xpath = dh.createXPath("/html/body/div/div[3]/div[2]");
//                            List<Element> nodes=  xpath.selectNodes(dh);
//                            int iH3=0;
//                            for(Iterator it = root.elementIterator(); it.hasNext();) {
//                                Element elH3 = (Element) it.next();
//                                iH3++;
//                                if(iH3<2) continue;;
//                                List<Element>   elAs =elH3.elements("a");
//                                log.d("省市区："+elAs.get(0).getTextTrim());

                        } catch (Exception e) {
                            e.printStackTrace();
                        }


                    }});


    }


    public void close() {
//        OkHttpClient的线程池和连接池在空闲的时候会自动释放，所以一般情况下不需要手动关闭，但是如果出现极端内存不足的情况，可以使用以下代码释放内存：
        try {

            okHttpClient.connectionPool().evictAll();                 //清除并关闭连接池
            log.d("OKHTTP connections iddle: {}, all: {}", okHttpClient.connectionPool().idleConnectionCount(),
                    okHttpClient.connectionPool().connectionCount());
            okHttpClient.dispatcher().executorService().shutdown();   //清除并关闭线程池
            try {
                okHttpClient.dispatcher().executorService().awaitTermination(10 * 1000, TimeUnit.MILLISECONDS);
                log.d("OKHTTP ExecutorService closed.");
            } catch (InterruptedException e) {
                log.d("InterruptedException on destroy()", e);
            }
//            okHttpClient.cache().close();
        } catch (Exception e) {
            log.e(e);
        }
    }
}
