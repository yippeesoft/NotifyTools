package org.github.yippee.netty.socketio;


//https://www.cnblogs.com/wxgblogs/p/6852470.html

import com.corundumstudio.socketio.*;
import com.corundumstudio.socketio.annotation.OnConnect;
import com.corundumstudio.socketio.annotation.OnDisconnect;
import com.corundumstudio.socketio.annotation.OnEvent;
import com.corundumstudio.socketio.listener.ConnectListener;
import com.corundumstudio.socketio.listener.DataListener;
import com.corundumstudio.socketio.listener.DisconnectListener;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class SocketIOServers {
    private Map<String, SocketIOClient> clients = new ConcurrentHashMap<>();
    public void start(){
        SocketConfig socketConfig = new SocketConfig();
        socketConfig.setReuseAddress(true);
        socketConfig.setTcpNoDelay(true);
        socketConfig.setTcpKeepAlive(true);

//        socketConfig.setSoLinger(0);
        Configuration config = new Configuration();
        config.setPort(9999);
        config.setSocketConfig(socketConfig);
        config.setPingTimeout(6000000);
        config.setUpgradeTimeout(1000000);
        config.setPingInterval(25000);
        config.setBossThreads(2);
        config.setWorkerThreads(1000);

        config.setAllowCustomRequests(true);
//        config.setHostname("localhost");
        SocketIOServer server = new SocketIOServer(config);
//        server.addListeners(new EventListennter());
        server.addConnectListener(new ConnectListener() {
            @Override
            public void onConnect(SocketIOClient client) {
                System.out.println(clients.size()+"建立连接 "+client.getSessionId());
                clients.put(client.getSessionId()+"",client);
            }
        });
        server.addDisconnectListener(new DisconnectListener() {
            @Override
            public void onDisconnect(SocketIOClient client) {
                System.out.println(clients.size()+"关闭连接 "+client.getSessionId());
                clients.remove(client.getSessionId()+"");
            }
        });
        server.addEventListener("/api/v1/box/login", String.class, new DataListener<String>() {
            @Override
            public void onData(SocketIOClient client, String data, AckRequest ackSender) throws Exception {
                System.out.println(clients.size()+"接收数据 "+data);
            }
        });
        server.start();
        System.out.println("启动正常");
    }


    public class EventListennter {

        //维护每个客户端的SocketIOClient
        private Map<String, SocketIOClient> clients = new ConcurrentHashMap<>();

        @OnConnect
        public void onConnect(SocketIOClient client) {
            System.out.println("建立连接 "+client.getSessionId());
            clients.put(client.getSessionId()+"",client);
        }

//        @OnEvent("token")
//        public void onToken(SocketIOClient client,String message) {
//            List<SocketIOClient> socketList = clients.get(message.getToken());
//            if (null == socketList || socketList.isEmpty()) {
//                List<SocketIOClient> list = new ArrayList<>();
//                list.add(client);
//                clients.put(message.getToken(), list);
//            }
//            System.err.println("get token Message is " + message.getToken());
//        }

        /**
         * 新事务
         * @param client 客户端
         * @param message 消息
         */
        @OnEvent("/api/v1/box/login")
        public void onLogin(SocketIOClient client, String message) {
            System.out.println("onLogin " + message);
            //send to all users
//            Collection<List<SocketIOClient>> clientsList = clients.values();
//            for (List<SocketIOClient> list : clientsList) {
//                for (SocketIOClient socketIOClient : list) {
//                    socketIOClient.sendEvent("newAlert", message);
//                }
//            }
        }

//        /**
//         * 通知所有在线客户端
//         */
//        public void sendAllUser() {
//            Set<Entry<String,List<SocketIOClient>>> entrySet = clients.entrySet();
//            for (Entry<String, List<SocketIOClient>> entry : entrySet) {
//                String key = entry.getKey();
//                List<SocketIOClient> value = entry.getValue();
//                for (SocketIOClient socketIOClient : value) {
//                    SocketIOMessage message = new SocketIOMessage();
//                    message.setMessage("send All user Msg" + key);
//                    socketIOClient.sendEvent("newAlert", message);
//                }
//            }
//        }

        @OnDisconnect
        public void onDisconnect(SocketIOClient client) {
            System.out.println("关闭连接 "+client.getSessionId());
        }
    }
    public static void main(String[] args) throws  Exception {
        SocketIOServers socketIOServers=new SocketIOServers();
        socketIOServers.start();
        Thread.sleep(Integer.MAX_VALUE);
        System.out.println("end " );
    }
}
