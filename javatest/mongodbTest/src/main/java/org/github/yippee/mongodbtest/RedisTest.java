package org.github.yippee.mongodbtest;

import org.redisson.Redisson;
import org.redisson.api.RBucket;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import redis.clients.jedis.Jedis;

import java.util.List;
import java.util.Set;

public class RedisTest {

    public static void main(String[] args){
        redissonTest();
    }

    public static void redissonTest(){
        //创建配置
        Config config = new Config();
//指定使用单节点部署方式
        config.useSingleServer().setAddress("redis://192.168.65.157:6379");
//创建客户端(发现这一非常耗时，基本在2秒-4秒左右)
        RedissonClient redisson = Redisson.create(config);

//首先获取redis中的key-value对象，key不存在没关系
        RBucket<String> keyObject = redisson.getBucket("key");
//如果key存在，就设置key的值为新值value
//如果key不存在，就设置key的值为value
        keyObject.set("value");
        System.out.println("输出内容为：" + keyObject.get( ));
//最后关闭RedissonClient
        redisson.shutdown();
    }
    public static void jedisTest(){
        //连接redis ，redis的默认端口是6379

        Jedis  jedis = new Jedis ("192.168.65.157",6379);



//验证密码，如果没有设置密码这段代码省略

        jedis.auth("admin");



        jedis.connect();//连接





        Set<String> keys = jedis.keys("*"); //列出所有的key

        keys = jedis.keys("key"); //查找特定的key
        //设置字符串数据
        jedis.set("myKey", "testStr");
        //通过key输出缓存内容
        System.out.println("输出内容为：" + jedis.get("myKey"));

        //存储List缓存数据
        jedis.lpush("test-list", "Java");
        jedis.lpush("test-list", "PHP");
        jedis.lpush("test-list", "C++");
        //获取list缓存数据
        List<String> listCache = jedis.lrange("test-list", 1, 1);
        for (int i = 0; i < listCache.size(); i++) {
            System.out.println("缓存输出：" + listCache.get(i));
        }

//        ---------------------
//                作者：小草mlc
//        来源：CSDN
//        原文：https://blog.csdn.net/mlc1218559742/article/details/52668429
//        版权声明：本文为博主原创文章，转载请附上博文链接！
//
        jedis.disconnect();//断开连接
    }
}
