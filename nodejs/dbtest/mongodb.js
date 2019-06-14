 
const MongoClient = require('mongodb').MongoClient;
var url = 'mongodb://admin:admin@192.168.1.143:27017/?authSource=admin&ssh=true';
const dbName = 'DPSZ31';
console.time('testConn')


MongoClient.connect(url, { useNewUrlParser: true }, function(err, client) {
    const db = client.db(dbName);
	console.timeEnd('testConn')
	console.time('MongoClient')
	
    var list = [];
    var query = {};
    
    query['picture'] =0;
    query["_id"] = 0;

    const result =    db.collection("personList"). find({} ).project({picture:0}) ;
    result.toArray(function (err,datas) {
        console.log("result "+datas.length  );
       
        console.timeEnd('MongoClient')
    });
       
 
     
  });

  

 'use strict';

 const mongoose = require('mongoose');
   url = 'mongodb://admin:admin@192.168.1.143:27017/DPSZ31?authSource=admin&ssh=true';
// const dbName = 'DPSZ31';

 mongoose.connect(url);
 const con = mongoose.connection;
 con.on('error', console.error.bind(console, '连接数据库失败'));
 con.once('open',()=>{
     console.log("open" );
     //定义一个schema
     
    let schema = mongoose.Schema({
        personId:String,
        picMd5:String
    });
  
    console.time('mongoose')
    var personList2 = mongoose.model('personlist2', schema);    
    personList2.find({},'personId picMd5')  .exec(function(err,docs){
        console.log("len:"+docs.length);
        console.timeEnd('mongoose')
    })
    // doc1.save(function (err,doc) {
      
    //       console.log(doc);
    //       console.time('testAA')
         
    //     })
      
 })