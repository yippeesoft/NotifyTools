package org.github.yippee.mongodbtest;

import com.google.gson.JsonObject;
import com.mongodb.BasicDBObject;
import com.mongodb.MongoTimeoutException;
import com.mongodb.reactivestreams.client.MongoClients;
import com.mongodb.reactivestreams.client.MongoCollection;
import com.mongodb.reactivestreams.client.MongoDatabase;
import org.bson.Document;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static java.lang.String.format;

public class MongoAsyncTest {
    public MongoAsyncTest(){

    }


    public String getPersonListJsonasync(String connstr){
        final long[] start = {System.currentTimeMillis()};

        try {
            // 连接到 mongodb 服务
            com.mongodb.reactivestreams.client.MongoClient mongoClient = MongoClients.create(connstr);

// 连接到数据库
            MongoDatabase db = mongoClient.getDatabase("DPSZ31");

            BasicDBObject condition = new BasicDBObject();
            // condition.append("name", "xph");
            BasicDBObject keys = new BasicDBObject();
            keys.put("_id", 0);
            keys.put("picture",0);

            Document doc = new Document(). append("picture",0);//.append("pwd",1);//指定查询字段，0为不包含此字段，1为包含此字段

            System.out.println(" started! " + start[0]);
            MongoCollection<Document> collection = db.getCollection("personList");
            PrintSubscriber subscriber = new PrintSubscriber("Text search matches: %s");

            System.out.println(" 1 耗时! " + (System.currentTimeMillis() - start[0]));
//                        collection.countDocuments().subscribe(subscriber);
//            try {
//                subscriber.await();
//            } catch (Throwable throwable) {
//                throwable.printStackTrace();
//            }
//            System.out.println(" 2 耗时! " + (System.currentTimeMillis() - start[0]));
            start[0] = System.currentTimeMillis();
            Publisher<Document> publisher = collection.find()  .projection(doc);
//            publisher.subscribe(new PrintDocumentSubscriber());

            publisher.subscribe(new Subscriber<Document>() {
                    int kkk=0;
                  @Override
                  public void onSubscribe(Subscription s) {
                      System.out.println("onSubscribe");

                      s.request(Integer.MAX_VALUE);
                  }

                  @Override
                  public void onNext(Document document) {
//                      System.out.println("onNext");
                      kkk++;
                  }

                  @Override
                  public void onError(Throwable t) {
                      System.out.println("onError");
                  }

                  @Override
                  public void onComplete() {
                      System.out.println("onComplete "+kkk);
                      System.out.println(" 异步  耗时! " + (System.currentTimeMillis() - start[0]));
                  }
              });








        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println(" 耗时! " + (System.currentTimeMillis() - start[0]));
        return null;
    }
    public static class PrintSubscriber<T> extends OperationSubscriber<T> {
        private final String message;

        /**
         * A Subscriber that outputs a message onComplete.
         *
         * @param message the message to output onComplete
         */
        public PrintSubscriber(final String message) {
            this.message = message;
        }

        @Override
        public void onComplete() {
            System.out.println(format(message, getReceived()));
            super.onComplete();
        }
    }

    public static class PrintDocumentSubscriber extends OperationSubscriber<Document> {

        @Override
        public void onNext(final Document document) {
            super.onNext(document);
            System.out.println(document.toJson());
        }
    }
    public static class OperationSubscriber<T> extends ObservableSubscriber<T> {

        @Override
        public void onSubscribe(final Subscription s) {
            super.onSubscribe(s);
            s.request(Integer.MAX_VALUE);
        }
    }

    public static class ObservableSubscriber<T> implements Subscriber<T> {
        private final List<T> received;
        private final List<Throwable> errors;
        private final CountDownLatch latch;
        private volatile Subscription subscription;
        private volatile boolean completed;

        ObservableSubscriber() {
            this.received = new ArrayList<T>();
            this.errors = new ArrayList<Throwable>();
            this.latch = new CountDownLatch(1);
        }

        @Override
        public void onSubscribe(final Subscription s) {
            subscription = s;
        }

        @Override
        public void onNext(final T t) {
            received.add(t);
        }

        @Override
        public void onError(final Throwable t) {
            errors.add(t);
            onComplete();
        }

        @Override
        public void onComplete() {
            completed = true;
            latch.countDown();
        }

        public Subscription getSubscription() {
            return subscription;
        }

        public List<T> getReceived() {
            return received;
        }

        public Throwable getError() {
            if (errors.size() > 0) {
                return errors.get(0);
            }
            return null;
        }

        public boolean isCompleted() {
            return completed;
        }

        public List<T> get(final long timeout, final TimeUnit unit) throws Throwable {
            return await(timeout, unit).getReceived();
        }

        public ObservableSubscriber<T> await() throws Throwable {
            return await(Long.MAX_VALUE, TimeUnit.MILLISECONDS);
        }

        public ObservableSubscriber<T> await(final long timeout, final TimeUnit unit) throws Throwable {
            subscription.request(Integer.MAX_VALUE);
            if (!latch.await(timeout, unit)) {
                throw new MongoTimeoutException("Publisher onComplete timed out");
            }
            if (!errors.isEmpty()) {
                throw errors.get(0);
            }
            return this;
        }
    }

    public static void main(String[] args){
        String connstr="mongodb://admin:admin@192.168.1.143:27017/?authSource=admin&ssh=true";
//        MongoClientSettings.Builder builder= MongoClientSettings.builder();
        int maxPoolSize = 42;
        int minPoolSize = maxPoolSize / 2; // min needs to be less then max
        long maxIdleTimeMS = Math.abs(1);
        long maxLifeTimeMS = Math.abs(2);
        // Do not use long because of rounding.
        int waitQueueMultiple = 5432;
        long waitQueueTimeoutMS = Math.abs(3);
        long maintenanceInitialDelayMS = Math.abs(4);
        long maintenanceFrequencyMS = Math.abs(5);

        JsonObject config = new JsonObject();

        config.addProperty("maxPoolSize", maxPoolSize);
        config.addProperty("minPoolSize", minPoolSize);
        config.addProperty("maxIdleTimeMS", maxIdleTimeMS);
        config.addProperty("maxLifeTimeMS", maxLifeTimeMS);
        config.addProperty("waitQueueMultiple", waitQueueMultiple);
        config.addProperty("waitQueueTimeoutMS", waitQueueTimeoutMS);
        config.addProperty("maintenanceInitialDelayMS", maintenanceInitialDelayMS);
        config.addProperty("maintenanceFrequencyMS", maintenanceFrequencyMS);


        MongoAsyncTest dpsMongoTest=new MongoAsyncTest( );
//        dpsMongoTest.init();
//        dpsMongoTest.initPersonList(connstr);
        dpsMongoTest.getPersonListJsonasync(connstr);

//        dpsMongoTest.bulkWriteInsert(connstr);
        try {
            new BufferedReader(new InputStreamReader(System.in)).readLine();
            //怎么让程序一直运行
            Scanner scan=new Scanner(System.in);
            while(true){
                scan.hasNext();
                Thread.sleep(500);
                String in = scan.next().toString();
                if (in.equals(in.toUpperCase()) ||
                        in.substring(0, 1).equals(in.toUpperCase())) {
                    System.out.println("您成功已退出！");
                    break;
                }
                System.out.println("您输入的值："+in);
            }


//            System.in.read();

//            while(true){
//                synchronized(lock){
//                    System.out.println( "2.无限期等待中..." );
//                    lock.wait();
//
//                }
//            }
        } catch ( Exception e) {
            e.printStackTrace();
        }
        System.out.println("aaaa end");
    }
}
