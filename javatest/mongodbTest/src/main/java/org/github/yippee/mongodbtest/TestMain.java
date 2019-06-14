package org.github.yippee.mongodbtest;

public class TestMain {
    public static void main(String[] args) throws InterruptedException {
        String connstr = "mongodb://admin:admin@192.168.1.143:27017/?authSource=admin&ssh=true";

//        MongoTest mongoTest=new MongoTest();
//        mongoTest.getPersonListJsonSync(connstr);

        MongoAsyncTest mongoAsyncTest=new MongoAsyncTest();
        mongoAsyncTest.getPersonListJsonasync(connstr);

        Thread.sleep(10*1000);
    }
}
