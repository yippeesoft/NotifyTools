package org.github.yippee.mongodbtest;

import com.mongodb.BasicDBObject;
import com.mongodb.client.*;
import org.bson.Document;

public class MongoTest {
    public MongoTest(){

    }

    public MongoTest(String connstr){

    }


    public String getPersonListJsonSync(String connstr){
        long start = System.currentTimeMillis();

        try {
            // 连接到 mongodb 服务
            MongoClient mongoClient = MongoClients.create(connstr);

// 连接到数据库
            MongoDatabase db = mongoClient.getDatabase("DPSZ31");

            BasicDBObject condition = new BasicDBObject();
            // condition.append("name", "xph");
            BasicDBObject keys = new BasicDBObject();
            keys.put("_id", 0);
            keys.put("picture",0);

            Document doc = new Document(). append("picture",0);//.append("pwd",1);//指定查询字段，0为不包含此字段，1为包含此字段

            System.out.println("getPersonListJson started! " + start);
            MongoCollection<Document> collection = db.getCollection("personList2");

            System.out.println("  1 耗时! " + (System.currentTimeMillis() - start));
            FindIterable<Document> findIterable = collection.find().projection(doc);

            System.out.println("  2 耗时! " + (System.currentTimeMillis() - start));

            System.out.println("  3 耗时! " + (System.currentTimeMillis() - start));

            start = System.currentTimeMillis();
            MongoCursor<Document> mongoCursor = db.getCollection("personList").find( ).projection(doc).iterator();
            System.out.println(mongoCursor.hasNext()+" 同步获取 time: " + (System.currentTimeMillis() - start));

//            while(mongoCursor.hasNext()){
//                WsRecMsg.DataEntity dataEntity=new WsRecMsg.DataEntity();
////                dataEntity=gson.fromJson(mongoCursor.next().toJson(),msg.class);
//                Document document=mongoCursor.next();
//                dataEntity.setPersonId(document.getString("personId"));
//                dataEntity.setPicMd5(document.getString("picMd5"));
//                list.add(dataEntity);
//            }

            mongoClient.close();


        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("  耗时! " + (System.currentTimeMillis() - start));
        return null;
    }


//
//    public static void main(String[] args){
//        String connstr="mongodb://admin:admin@192.168.1.143:27017/?authSource=admin&ssh=true";
//        MongoClientSettings.Builder builder= MongoClientSettings.builder();
//        int maxPoolSize = 42;
//        int minPoolSize = maxPoolSize / 2; // min needs to be less then max
//        long maxIdleTimeMS = Math.abs(1);
//        long maxLifeTimeMS = Math.abs(2);
//        // Do not use long because of rounding.
//        int waitQueueMultiple = 5432;
//        long waitQueueTimeoutMS = Math.abs(3);
//        long maintenanceInitialDelayMS = Math.abs(4);
//        long maintenanceFrequencyMS = Math.abs(5);
//
//        JsonObject config = new JsonObject();
//
//        config.addProperty("maxPoolSize", maxPoolSize);
//        config.addProperty("minPoolSize", minPoolSize);
//        config.addProperty("maxIdleTimeMS", maxIdleTimeMS);
//        config.addProperty("maxLifeTimeMS", maxLifeTimeMS);
//        config.addProperty("waitQueueMultiple", waitQueueMultiple);
//        config.addProperty("waitQueueTimeoutMS", waitQueueTimeoutMS);
//        config.addProperty("maintenanceInitialDelayMS", maintenanceInitialDelayMS);
//        config.addProperty("maintenanceFrequencyMS", maintenanceFrequencyMS);
//
//
//        DpsMongoTest dpsMongoTest=new DpsMongoTest( );
////        dpsMongoTest.init();
////        dpsMongoTest.initPersonList(connstr);
//
//
////        dpsMongoTest.bulkWriteInsert(connstr);
//    }
}
