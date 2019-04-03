package com.example.adbwifi;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.text.TextUtils;
import android.util.Log;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;

public class NetWorkUtils {

	public static boolean checkEnable(Context paramContext) {
		boolean i = false;
		NetworkInfo localNetworkInfo = ((ConnectivityManager) paramContext
				.getSystemService("connectivity")).getActiveNetworkInfo();
		if ((localNetworkInfo != null) && (localNetworkInfo.isAvailable()))
			return true;
		return false;
	}

	public static String int2ip(int ipInt) {
        StringBuilder sb = new StringBuilder();
        sb.append(ipInt & 0xFF).append(".");
        sb.append((ipInt >> 8) & 0xFF).append(".");
        sb.append((ipInt >> 16) & 0xFF).append(".");
        sb.append((ipInt >> 24) & 0xFF);
        return sb.toString();
}
	/**
	 * 得到无线网关的IP地址
	 *
	 * @return
	 */
	private static String getAllIp() {

		try {
			// 获取本地设备的所有网络接口
			Enumeration<NetworkInterface> enumerationNi = NetworkInterface
					.getNetworkInterfaces();
			while (enumerationNi.hasMoreElements()) {
				NetworkInterface networkInterface = enumerationNi.nextElement();
				String interfaceName = networkInterface.getDisplayName();
				Log.i("tag", "网络名字" + interfaceName);
				if(interfaceName.startsWith("eth")) {
					Enumeration<InetAddress> enumIpAddr = networkInterface
							.getInetAddresses();

					while (enumIpAddr.hasMoreElements()) {
						// 返回枚举集合中的下一个IP地址信息
						InetAddress inetAddress = enumIpAddr.nextElement();
						if (!inetAddress.isLoopbackAddress()
								&& inetAddress instanceof Inet4Address) {
							Log.i("tag", inetAddress.getHostAddress() + "   ");

							return inetAddress.getHostAddress();
						}

					}
				}
			}

		} catch (SocketException e) {
			e.printStackTrace();
		} catch ( Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	public static String getLocalIpAddress(Context context) {
		try {
//			for (Enumeration<NetworkInterface> en = NetworkInterface
//					.getNetworkInterfaces(); en.hasMoreElements();) {
//				NetworkInterface intf = en.nextElement();
//				for (Enumeration<InetAddress> enumIpAddr = intf
//						.getInetAddresses(); enumIpAddr.hasMoreElements();) {
//					InetAddress inetAddress = enumIpAddr.nextElement();
//					if (!inetAddress.isLoopbackAddress()) {
//						return inetAddress.getHostAddress().toString();
//					}
//				}
//			}
			String s=getAllIp();
			if(TextUtils.isEmpty(s)==false)
				return s;
			WifiManager wifiManager = (WifiManager)context.getSystemService(Context.WIFI_SERVICE);  
			WifiInfo wifiInfo = wifiManager.getConnectionInfo();  
			int i = wifiInfo.getIpAddress(); 
			return int2ip(i);
		} catch (Exception ex) {
			return " 获取IP出错鸟!!!!请保证是WIFI,或者请重新打开网络!\n"+ex.getMessage();
		}
		// return null;
	}
}