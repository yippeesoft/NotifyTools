var express = require('express');
var app = express();
var fs = require("fs");

var bodyParser = require('body-parser');
var multer  = require('multer');
var router = express.Router();
var upload = multer({dest:'file_upload/'});

var fly=require("flyio")
 
const path=require('path');
var log = require("log4js");

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(multer({ dest: './file_upload'}).array('file'));

app.get('/index.html', function (req, res) {
  console.log(req);  // 上传的文件信息
   res.sendFile( __dirname + "/" + "index.htm" );
})

app.post('/file_upload', function (req, res) {
  console.log(req);  // 上传的文件信息
  console.log("file:\n\n"+req.files[0]);  // 上传的文件信息

  var des_file = __dirname + "/" + req.files[0].originalname;
  fs.readFile( req.files[0].path, function (err, data) {
       fs.writeFile(des_file, data, function (err) {
        if( err ){
             console.log( err );
        }else{
              response = {
                  message:'File uploaded successfully', 
                  filename:req.files[0].originalname
             };

             var formData = {
              name:"v.png", //普通的字段
              playtime:"10",
              file: fs.createReadStream(req.files[0].originalname), //文件
              // resume: fs.createReadStream('./resume.docx'), //文件
              // attachments:[ //可以通过数组
              //     fs.createReadStream('./file1.zip'),
              //     fs.createReadStream('./file2.zip')
              // ]
          }
          
          fly.upload("http://192.168.1.2:7005/uploadplay", formData)
              .then(log).catch(log)

         }
         console.log( response );
         res.end( JSON.stringify( response ) );
      });
  });
})

var server = app.listen(8081, function () {

 var host = server.address().address
 var port = server.address().port

 console.log("应用实例，访问地址为 http://%s:%s", host, port)

})

// router.post("/api/upload", async (req, res) => {  
//   let upload = multer(uploadCfg).any();  
//   upload(req, res, async (err) => {  
//     if (err) {  
//       res.json({ path: `//uploads/tmp/${uploadFile.filename}` });  
//       console.log(err);  
//       return;  
//     };  
//     console.log(req.files);  
//     let uploadFile = req.files[0];  
//     res.json({ path: `//uploads/tmp/${uploadFile.filename}` });  
//   });  
// })
