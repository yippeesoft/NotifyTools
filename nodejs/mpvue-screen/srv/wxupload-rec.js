var express = require('express');
var app = express();
var fs = require("fs");

var bodyParser = require('body-parser');
var multer  = require('multer');
var router = express.Router();
var upload = multer({dest:'file_upload/'});

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(multer({ dest: './file_upload'}).array('file'));

app.get('/index.html', function (req, res) {
  console.log(req);  // 上传的文件信息
   res.sendFile( __dirname + "/" + "index.htm" );
})

app.post('/file_upload', function (req, res) {
  console.log(req);  // 上传的文件信息
  console.log(req.files[0]);  // 上传的文件信息

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
