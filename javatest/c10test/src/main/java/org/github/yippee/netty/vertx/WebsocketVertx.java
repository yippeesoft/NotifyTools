package org.github.yippee.netty.vertx;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.ServerWebSocket;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;

import java.util.HashMap;
import java.util.Map;


//VERTX不支持socketio There is no support for socket.io at the moment however we do have support for sockjs. 
public class WebsocketVertx extends AbstractVerticle {
    // 保存每一个连接到服务器的通道
    private Map<String, ServerWebSocket> connectionMap = new HashMap<>(16);

    @Override
    public void start() throws Exception {

        HttpServer server = vertx.createHttpServer();

        Router router = Router.router(vertx);

        router.route("/").handler(routingContext -> {
//            routingContext.response().sendFile("html/ws.html");
            routingContext.response().write("AAAAAAAAAA");
        });
        router.route("/aaa").handler(new Handler<RoutingContext>() {
            @Override
            public void handle(RoutingContext event) {

            }
        });
        websocketMethod(server);
        server.requestHandler(router::accept).listen(9999);
    }

    public void websocketMethod(HttpServer server) {
        server.websocketHandler(webSocket -> {
            // 获取每一个链接的ID
            String id = webSocket.binaryHandlerID();
            // 判断当前连接的ID是否存在于map集合中，如果不存在则添加进map集合中
            if (!checkID(id)) {
                connectionMap.put(id, webSocket);
            }
            System.out.println(connectionMap.size()+"建立连接 "+id);
            webSocket.writeTextMessage("CCCCCCCCCc");
            //　WebSocket 连接
            webSocket.frameHandler(handler -> {
                String textData = handler.textData();
                String currID = webSocket.binaryHandlerID();

                //给非当前连接到服务器的每一个WebSocket连接发送消息
                for (Map.Entry<String, ServerWebSocket> entry : connectionMap.entrySet()) {
                    if (currID.equals(entry.getKey())) {
                        continue;
                    }
                    /* 发送文本消息
                    文本信息似乎不支持图片等二进制消息
                    若要发送二进制消息，可用writeBinaryMessage方法
                    */
//                    entry.getValue().writeTextMessage(textData);
                }
            });

            // 客户端WebSocket 关闭时，将当前ID从map中移除
            webSocket.closeHandler(handler -> {connectionMap.remove(id) ;
            System.out.println(connectionMap.size()+"断开连接 "+id);});
        });
    }
    // 检查当前ID是否已经存在与map中
    public boolean checkID(String id) {
        return connectionMap.containsKey(id);
    }


        public static void main(String[] args) {
            Vertx vertx = Vertx.vertx();
            vertx.deployVerticle(WebsocketVertx.class.getName());
        }
//---------------------
//    作者：hz594556878
//    来源：CSDN
//    原文：https://blog.csdn.net/zhhactj/article/details/78728899
//    版权声明：本文为博主原创文章，转载请附上博文链接！
}
