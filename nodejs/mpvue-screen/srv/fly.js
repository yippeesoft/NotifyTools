var fly=require("flyio")
const fs=require('fs');
const path=require('path');
var log = require("log4js");
//上传单个文件
// var formData = {
//     file: fs.createReadStream('./v.png'), //文件
// }
// fly.upload("http://localhost/upload", formData)
//     .then(log).catch(log)

//可以包括多个字段／文件
var formData = {
    name:"v.png", //普通的字段
    playtime:"10",
    file: fs.createReadStream('./tmp_391a739dd7c4f757bd224dd015eabc5654b73d63b3fbb35d.jpg'), //文件
    // resume: fs.createReadStream('./resume.docx'), //文件
    // attachments:[ //可以通过数组
    //     fs.createReadStream('./file1.zip'),
    //     fs.createReadStream('./file2.zip')
    // ]
}

fly.upload("http://192.168.1.2:7005/uploadplay", formData)
    .then(log).catch(log)

